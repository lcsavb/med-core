$(document).ready(function () {
  // Handle login form submission
  $('#loginForm').on('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting the default way

    const username = $('#username').val();
    const password = $('#password').val();

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

      // BEFORE ISSUING TOKEN, THE 2FA CODE MUST BE VERIFIED
      if (response.ok) {
        // Store the temporary token in localStorage
        localStorage.setItem('temporary_token', data.temporary_token);

        // Show the 2FA code input form and hide the login form
        $('#loginContainer').hide();
        $('#codeContainer').show();
      } else {
        // Show an error message if login fails
        alert(data.message || 'Login failed, please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('An error occurred. Please try again.');
    }
  });

  // Function to handle code form submission
  $('#codeForm').on('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting the default way

    const authCode = $('#authCode').val(); // Get the entered 2FA code
    const temporaryToken = localStorage.getItem('temporary_token'); // Retrieve the temporary token

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

      if (response.ok) {
        // Handle success, save the access token
        localStorage.setItem('token', data.access_token); // Save the access token
        localStorage.removeItem('temporary_token'); // Remove the temporary token after successful authentication
        $('#codeContainer').hide();
        $('#authSuccessMessage').show();
      } else {
        // Handle failure
        alert(data.message || 'Code verification failed, please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('An error occurred. Please try again.');
    }
  });




  // Function to handle logout
  function logout() {
    // Remove the tokens from localStorage
    localStorage.removeItem('temporary_token');
    localStorage.removeItem('token');

    // Show the login form and hide the success message
    $('#loginContainer').show();
    $('#authSuccessMessage').hide();
    $('#statusResult').hide(); // Hide the status result
  }

  // Attach the logout function to the Logout button
  $('#logoutBtn').on('click', logout);

  // Function to check authentication status
  function checkAuthStatus() {
    const token = localStorage.getItem('token');
    const headers = token ? { 'Authorization': `Bearer ${token}` } : {};

    fetch('/auth/status', {
      method: 'GET',
      headers: headers,
    })
      .then(response => response.json())
      .then(data => {
        $('#statusResult').show();

        // Display the message directly from the backend
        if (data.message) {
          $('#statusResult').text(data.message);
        } else if (data.authenticated) {
          $('#statusResult').text(`Authenticated as: ${data.username}`);
        } else {
          $('#statusResult').text('Not authenticated.');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while checking authentication status.');
      });
  }

  // Attach the checkAuthStatus function to the "Check Status" button
  $('#checkStatusBtn').on('click', checkAuthStatus);

  // Check if token exists in localStorage and show success message if it does
  const token = localStorage.getItem('token');
  if (token) {
    // Send a request to check the login status
    fetch('/auth/status', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    })
      .then(response => response.json())
      .then(data => {
        if (data.authenticated) {
          // Token is valid, hide login form and show success message
          $('#loginContainer').hide();
          $('#authSuccessMessage').show();
        } else {
          // If not authenticated, remove token and show login form
          localStorage.removeItem('token');
          $('#loginContainer').show();
          $('#authSuccessMessage').hide();
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while checking authentication status.');
      });
  }
});
