$(document).ready(function () {
  console.log('Document ready');

  // Define the updateNavBar function globally
  window.updateNavBar = function () {
    const token = localStorage.getItem('token');
    console.log('updateNavBar called, token:', token);
    const navBar = $('nav ul');
    navBar.empty(); // Clear existing nav items

    if (token) {
      // If logged in, show Dashboard and Logout
      console.log('User is logged in, updating nav bar');
      navBar.append(`
        <li><a href="#" class="nav-link" data-page="clinics" data-script="clinics.js" data-css="clinics.css">Clinics</a></li>
        <li><a href="#" class="nav-link" data-page="patients" data-script="patients.js" data-css="patients.css">Patients</a></li>
        <li><a href="#" class="nav-link" data-page="frontdesk" data-script="frontdesk.js" data-css="frontdesk.css">Front Desk</a></li>
        <li><a href="#" class="nav-link" data-page="dashboard" data-script="dashboard.js" data-css="dashboard.css">Dashboard</a></li>
        <li><a href="#" id="logoutBtn" class="nav-link">Logout</a></li>
      `);

      // Attach the logout function to the Logout button
      $('#logoutBtn').on('click', function () {
        console.log('Logout button clicked');
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
          <li><a href="#" class="nav-link" data-page="register" data-script="register.js" data-css="register.css">Register</a></li>
        `);
      });
    } else {
      // If not logged in, show the default links
      console.log('User is not logged in, showing default nav bar');
      navBar.append(`
        <li><a href="#" class="nav-link" data-page="home" data-script="home.js" data-css="home.css">Home</a></li>
        <li><a href="#" class="nav-link" data-page="about">About</a></li>
        <li><a href="#" class="nav-link" data-page="contact">Contact</a></li>
        <li><a href="#" class="nav-link" data-page="login" data-script="login.js" data-css="login.css">Login</a></li>
        <li><a href="#" class="nav-link" data-page="register" data-script="register.js" data-css="register.css">Register</a></li>
      `);
    }
  };

  // Function to show the custom alert box
  function showCustomAlert(message) {
    console.log('Custom Alert Message:', message); // Debugging statement
    $('#customAlertMessage').text(message);
    $('#customAlert').fadeIn();
  }

  // Handle login form submission
  $('#loginForm').on('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting the default way
    console.log('Login form submitted');

    const username = $('#username').val();
    const password = $('#password').val();
    console.log('Username:', username, 'Password:', password);

    try {
      // Send login request to the server
      const response = await fetch('/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          username: username,
          password: password,
        }),
      });

      const data = await response.json();
      console.log('Login response:', data);

      // BEFORE ISSUING TOKEN, THE 2FA CODE MUST BE VERIFIED
      if (response.ok) {
        console.log('Login successful, storing temporary token');
        // Store the temporary token in localStorage
        localStorage.setItem('temporary_token', data.temporary_token);

        // Show the 2FA code input form and hide the login form
        $('#loginContainer').hide();
        $('#codeContainer').show();
      } else {
        // Show an error message if login fails
        showCustomAlert(data.message || 'Login failed, please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      showCustomAlert('An error occurred. Please try again.');
    }
  });

  // Handle 2FA code submission
  $('#codeForm').on('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting the default way
    console.log('2FA code form submitted');

    const authCode = $('#authCode').val(); // Get the entered 2FA code
    const temporaryToken = localStorage.getItem('temporary_token'); // Retrieve the temporary token
    console.log('Auth Code:', authCode, 'Temporary Token:', temporaryToken);

    try {
      const response = await fetch('/auth/verify-2fa', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${temporaryToken}` // Include the temporary token in the Authorization header
        },
        body: JSON.stringify({
          verification_code: authCode // Send the 2FA code for verification
        }),
      });

      const data = await response.json();
      console.log('2FA verification response:', data);

      if (response.ok) {
        console.log('2FA verification successful, storing access token');
        // Handle success, save the access token
        localStorage.setItem('token', data.access_token); // Save the access token
        localStorage.removeItem('temporary_token'); // Remove the temporary token after successful authentication
        $('#codeContainer').hide();
        $('#authSuccessMessage').show();

        // Update the navigation bar
        updateNavBar();
      } else {
        // Handle failure
        showCustomAlert(data.message || 'Code verification failed, please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      showCustomAlert('An error occurred. Please try again.');
    }
  });

  // Check authentication status on page load
  const token = localStorage.getItem('token');
  console.log('Checking authentication status, token:', token);
  if (token) {
    fetch('/auth/status', {
      method: 'GET',
      headers: { 'Authorization': `Bearer ${token}` },
    })
      .then((response) => response.json())
      .then((data) => {
        console.log('Authentication status response:', data);
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
        showCustomAlert('An error occurred while checking authentication status.');
      });
  } else {
    updateNavBar(); // Initialize the nav bar for non-authenticated users
  }

  // Close the custom alert box when the close button is clicked
  $('.custom-alert-close').on('click', function () {
    console.log('Custom alert close button clicked');
    $('#customAlert').fadeOut();
  });
});