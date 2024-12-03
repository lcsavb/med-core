// function updateNavBar() {
//     const token = localStorage.getItem('token');
//     const navBar = $('nav ul');
//     navBar.empty(); // Clear existing nav items
  
//     if (token) {
//       // If logged in, show the new navigation links
//       navBar.append(`
//         <li><a href="#" class="nav-link" data-page="patients" data-script="patients.js" data-css="patients.css">Patients</a></li>
//         <li><a href="#" class="nav-link" data-page="clinics" data-script="clinics.js" data-css="clinics.css">Clinics</a></li>
//         <li><a href="#" class="nav-link" data-page="frontdesk" data-script="frontdesk.js" data-css="frontdesk.css">Front Desk</a></li>
//         <li><a href="#" class="nav-link" data-page="dashboard" data-script="dashboard.js" data-css="dashboard.css">Dashboard</a></li>
//         <li><a href="#" id="logoutBtn" class="nav-link">Logout</a></li>
//       `);
  
//       // Attach the logout function to the Logout button
//       $('#logoutBtn').on('click', function () {
//         // Remove the tokens from localStorage
//         localStorage.removeItem('temporary_token');
//         localStorage.removeItem('token');
  
//         // Show the login form and hide the success message
//         $('#loginContainer').show();
//         $('#authSuccessMessage').hide();
//         $('#statusResult').hide(); // Hide the status result
  
//         // Restore the original navigation links
//         $('nav ul').html(`
//           <li><a href="#" class="nav-link" data-page="home" data-script="home.js" data-css="home.css">Home</a></li>
//           <li><a href="#" class="nav-link" data-page="about">About Us</a></li>
//           <li><a href="#" class="nav-link" data-page="contact">Contact</a></li>
//           <li><a href="#" class="nav-link" data-page="login" data-script="login.js" data-css="login.css">Login</a></li>
//           <li><a href="#" class="nav-link" data-page="register" data-script="register.js" data-css="register.css">Register</a></li>
//         `);
//       });
//     } else {
//       // If not logged in, show the default links
//       navBar.append(`
//         <li><a href="#" class="nav-link" data-page="home" data-script="home.js" data-css="home.css">Home</a></li>
//         <li><a href="#" class="nav-link" data-page="about">About</a></li>
//         <li><a href="#" class="nav-link" data-page="contact">Contact</a></li>
//         <li><a href="#" class="nav-link" data-page="login" data-script="login.js" data-css="login.css">Login</a></li>
//         <li><a href="#" class="nav-link" data-page="register" data-script="register.js" data-css="register.css">Register</a></li>
//       `);
//     }
//   }