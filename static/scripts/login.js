  // Function to handle login form submission
  document.getElementById('loginForm').addEventListener('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting the default way

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

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

      if (response.ok) {
        // Store the token in localStorage for future requests
        localStorage.setItem('token', data.token);

        // Hide the login form and show success message
        document.getElementById('loginContainer').style.display = 'none';
        document.getElementById('authSuccessMessage').style.display = 'block';
      } else {
        // Show an error message if login fails
        alert(data.message || 'Login failed, please try again.');
      }
    } catch (error) {
      console.error('Error:', error);
      alert('An error occurred. Please try again.');
    }
  });

  // Function to handle logout
  function logout() {
    // Remove the token from localStorage
    localStorage.removeItem('token');

    // Show the login form and hide the success message
    document.getElementById('loginContainer').style.display = 'block';
    document.getElementById('authSuccessMessage').style.display = 'none';
    document.getElementById('statusResult').style.display = 'none'; // Hide the status result
  }

  // Attach the logout function to the Logout button
  document.getElementById('logoutBtn').addEventListener('click', logout);

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
    const statusResult = document.getElementById('statusResult');
    statusResult.style.display = 'block';
    
    // Display the message directly from the backend
    if (data.message) {
      statusResult.innerText = data.message;
    } else if (data.authenticated) {
      statusResult.innerText = `Authenticated as: ${data.username}`;
    } else {
      statusResult.innerText = 'Not authenticated.';
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('An error occurred while checking authentication status.');
  });
}

  // Attach the checkAuthStatus function to the "Check Status" button
  document.getElementById('checkStatusBtn').addEventListener('click', checkAuthStatus);

  // Check if token exists in localStorage and show success message if it does
  document.addEventListener('DOMContentLoaded', function () {
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
          document.getElementById('loginContainer').style.display = 'none';
          document.getElementById('authSuccessMessage').style.display = 'block';
        } else {
          // If not authenticated, remove token and show login form
          localStorage.removeItem('token');
          document.getElementById('loginContainer').style.display = 'block';
          document.getElementById('authSuccessMessage').style.display = 'none';
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while checking authentication status.');
      });
    }
  });