$(document).ready(function () {
  // Define the updateNavBar function globally
  window.updateNavBar = function () {
    const token = localStorage.getItem('token');
    const navBar = $('nav ul');
    navBar.empty(); // Clear existing nav items

    if (token) {
      // If logged in, show Dashboard and Logout
      navBar.append(`
        <li><a href="/clinics" class="nav-link"">Clinics</a></li>
         <li><a href="/patients" class="nav-link"">Patients</a></li>
        <li><a href="/frontdesk" class="nav-link">Front Desk</a></li>
        <li><a href="/dashboard" class="nav-link">Dashboard</a></li>
        <li><a href="/logout" class="nav-link">Logout</a></li>
      `);

      // Attach the logout function to the Logout button
      $('#logoutBtn').on('click', function () {
        // Remove the tokens from localStorage
        localStorage.removeItem('temporary_token');
        localStorage.removeItem('token');

        // Show the login form and hide the success message
        $('#loginContainer').show();
        $('#authSuccessMessage').hide();
        $('#statusResult').hide(); // Hide the status result

        // Restore the original navigation links
        $('nav ul').html(`
          <li><a href="#" class="nav-link" data-page="home" data-script="home.js" data-css="home.css">Home</a></li>
          <li><a href="#" class="nav-link" data-page="about">About Us</a></li>
          <li><a href="#" class="nav-link" data-page="contact">Contact</a></li>
          <li><a href="#" class="nav-link" data-page="login" data-script="login.js" data-css="login.css">Login</a></li>
          <li><a href="#" class="nav-link" data-page="register" data-script="register.js" data-css="login.css">Register</a></li>
        `);
      });
    } else {
      // If not logged in, show the default links
      navBar.append(`
        <li>
          <a href="/home" class="nav-link">Home</a>
        </li>
        <li>
          <a href="/about" class="nav-link">About</a>
        </li>
        <li>
          <a href="/contact" class="nav-link">Contact</a>
        </li>
        <li>
          <a href="/login" class="nav-link">Login</a>
        </li>
        <li>
          <a href="/register" class="nav-link">Register</a>
        </li>
      `);
    }
  };

  // Handle login form submission
  $('#loginForm').on('submit', async function (event) {
    event.preventDefault();

    const username = $('#username').val();
    const password = $('#password').val();

    try {
      const response = await fetch('/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password }),
      });

      const data = await response.json();

      if (response.ok) {
        // Save temporary token and show 2FA form
        localStorage.setItem('temporary_token', data.temporary_token);
        $('#loginContainer').hide();
        $('#codeContainer').show();
      } else {
        alert(data.message || 'Login failed, please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('An error occurred. Please try again.');
    }
  });

  // Handle 2FA code submission
  $('#codeForm').on('submit', async function (event) {
    event.preventDefault();

    const authCode = $('#authCode').val();
    const temporaryToken = localStorage.getItem('temporary_token');

    try {
      const response = await fetch('/auth/verify-2fa', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${temporaryToken}`,
        },
        body: JSON.stringify({ verification_code: authCode }),
      });

      const data = await response.json();

      if (response.ok) {
        // Save access token, clear temp token, and update UI
        localStorage.setItem('token', data.access_token);
        localStorage.removeItem('temporary_token');
        $('#codeContainer').hide();
        $('#authSuccessMessage').show();

        // Update the navigation bar
        updateNavBar();
      } else {
        alert(data.message || 'Code verification failed, please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('An error occurred. Please try again.');
    }
  });

  // Handle logout
  $(document).on('click', '#logoutBtn', function () {
    localStorage.removeItem('token');
    localStorage.removeItem('temporary_token');

    // Update the UI
    $('#loginContainer').show();
    $('#authSuccessMessage').hide();

    // Reset the navigation bar
    updateNavBar();
    alert('You have been logged out.');
  });

  // Check authentication status on page load
  const token = localStorage.getItem('token');
  if (token) {
    fetch('/auth/status', {
      method: 'GET',
      headers: { 'Authorization': `Bearer ${token}` },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.authenticated) {
          $('#loginContainer').hide();
          $('#authSuccessMessage').show();
        } else {
          localStorage.removeItem('token');
          $('#loginContainer').show();
          $('#authSuccessMessage').hide();
        }
        updateNavBar();
      })
      .catch((error) => {
        console.error('Error:', error);
        alert('An error occurred while checking authentication status.');
      });
  } else {
    updateNavBar(); // Initialize the nav bar for non-authenticated users
  }
});