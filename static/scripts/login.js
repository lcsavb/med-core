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
    
  // Handle logout
  $(document).on('click', '#logoutBtn', function () {
    localStorage.removeItem('token');
    localStorage.removeItem('temporary_token');

    // Update the UI
    $('#loginContainer').show();
    $('#authSuccessMessage').hide();

    // Reset the navigation bar
    updateNavBar();
    showCustomAlert('You have been logged out.');
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
        showCustomAlert('An error occurred while checking authentication status.');
      });
    } else {
      updateNavBar(); // Initialize the nav bar for non-authenticated users
    }

    $(document).on('click', '.custom-alert-close', function () {
      console.log('Custom alert close button clicked');
      $('#customAlert').fadeOut();
    });

    $(document).on('click', '.forgot-password-link', function (event) {
      event.preventDefault(); // Prevent the default link behavior
      $('#loginContainer').hide();
      $('#forgotPasswordContainer').show();
  });
  
  $(document).on('submit', '#forgotPasswordForm', function (event) {
      event.preventDefault(); // Prevent the default form submission
  
      // Get the email value from the form
      const email = $('#email').val();
  
      // Perform an AJAX POST request to the API
      $.ajax({
          url: '/auth/forgot-password', // API endpoint
          method: 'POST',
          contentType: 'application/json',
          data: JSON.stringify({ email: email }), // Send email as JSON
          success: function (response) {
              // Save the token in localStorage
              localStorage.setItem('forgotPasswordToken', response.temporary_token);
  
              // Hide the forgot password container
              $('#forgotPasswordContainer').hide();
  
              // Show the code verification container
              $('#passwordContainer').show();
  
              console.log(response);
          },
          error: function (xhr) {
              // Handle error response
              const errorMessage = xhr.responseJSON?.error || 'An error occurred';
              showCustomAlert(errorMessage);
              console.log(xhr.responseJSON);
          }
      });
  });
  // Handle the 'verify code' form submission
  $(document).on('submit', '#passwordContainer', function (event) {
    event.preventDefault(); // Prevent the default form submission
    
    // Get the entered authentication code
    const authCode = $('#authCode1').val();
    
    // Retrieve the forgotPasswordToken from localStorage
    const forgotPasswordToken = localStorage.getItem('forgotPasswordToken');
    
    if (!forgotPasswordToken) {
      alert('No forgot password token found.');
      return;
    }

    // Perform an AJAX POST request to verify the code
    $.ajax({
        url: '/api/verify-password-reset', // API endpoint for verification
        method: 'POST',
        contentType: 'application/json',
        headers: {
            'Authorization': `Bearer ${forgotPasswordToken}` // Include the token in the Authorization header
        },
        data: JSON.stringify({ verification_code: authCode }), // Send entered code
        success: function (response) {
            // If verification is successful, show the new password container
            $('#passwordContainer').hide();  // Hide code verification form
            $('#newPasswordContainer').show();  // Show the new password form
            
        },
        error: function (xhr) {
            // Handle error response
            const errorMessage = xhr.responseJSON?.message || 'Failed to verify the code. Please try again.';
            showCustomAlert(errorMessage);
            console.log(xhr.responseJSON);
        }
    });
  });
  $(document).on('submit', '#newPasswordForm', function (event) {
    event.preventDefault(); // Prevent the default form submission

    const newPassword = $('#newPassword').val(); // Get the new password
    const confirmPassword = $('#confirmPassword').val(); // Get the confirm password

    // Check if both passwords match
    if (newPassword !== confirmPassword) {
      showCustomAlert('Passwords do not match. Please try again.');
      return;
    }

    // Retrieve the forgotPasswordToken from localStorage
    const forgotPasswordToken = localStorage.getItem('forgotPasswordToken');
    
    if (!forgotPasswordToken) {
      showCustomAlert('No forgot password token found.');
      return;
    }

    // Perform the AJAX request to update the password
    $.ajax({
      url: '/auth/update-password', // Backend endpoint for updating the password
      method: 'POST',
      contentType: 'application/json',
      headers: {
        'Authorization': `Bearer ${forgotPasswordToken}` // Include the token in the Authorization header
      },
      data: JSON.stringify({ new_password: newPassword }), // Send the new password
      success: function (response) {
        showCustomAlert('Your password has been successfully updated.');
        console.log(response);
        
        // Optionally, redirect the user or show a success message
        window.location.href = '/login'; // Redirect to login page
      },
      error: function (xhr) {
        const errorMessage = xhr.responseJSON?.message || 'Error updating password. Please try again.';
        showCustomAlert(errorMessage);
        console.log(xhr.responseJSON);
      }
    });
  });
  
});
