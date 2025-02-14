$(document).ready(function () {
    updateNavBar(); // Update the navigation bar based on the login status
  
    // Display the current date
    const currentDate = new Date().toLocaleDateString();
    $('#currentDate').text(`Current Date: ${currentDate}`);
  
    // Define the patients variable in the correct scope
    let appointments = [];
  
    // Function to load patient data
    function loadPatientData(date, doctorId, clinicId) {
      console.log('Loading patient data for date:', date); // Log the date parameter
      $.ajax({
        url: '0.0.0.0/api/patients',
        type: 'GET',
        data: {
          clinicId: clinicId,
          doctorId: doctorId,
          date: date,
        },
        success: function (response) {
          console.log('Data retrieved successfully:', response);
          appointments = response.appointments; // Assign the received data to the appointments variable
          loadPatientList(appointments);
        },
        error: function (_xhr, status, error) {
          console.error('Error fetching data:', status, error);
        }
      });
    }
  
    // Handle date picker button click
    $('#datePickerButton').on('click', function () {
      console.log('Date picker button clicked');
      $('#datePicker').toggle(); // Show or hide the date picker
    });
  
    // Handle date selection
    $('#datePicker').on('change', function () {
      const selectedDate = $(this).val();
      console.log('Selected date:', selectedDate);
      $('#currentDate').text(`Current Date: ${new Date(selectedDate).toLocaleDateString()}`);
      loadPatientData(selectedDate);
      $('#datePicker').hide(); // Hide the date picker after selection
    });
  
    // Load the list of patients
    const patientListElement = $('#patientList');
    function loadPatientList(filteredAppointments) {
      patientListElement.empty();
      filteredAppointments.forEach(appointment => {
        const appointmentTime = appointment.time;
        const patientName = `${appointment.first_name} ${appointment.last_name}`;
        const patientItem = $('<div></div>')
          .addClass('patient-item')
          .html(`
            <span class="patient-time">${appointmentTime}</span>
            <span class="patient-name">${patientName}</span>
          `)
          .on('click', () => showPatientDetails(appointment));
        patientListElement.append(patientItem);
      });
      console.log('Patient list loaded:', filteredAppointments);
    }
  
    // Show patient details
    function showPatientDetails(appointment) {
      $('#dashboardContainer').hide();
      $('#patientDetails').show();
      $('#anamnesisContent').html(`
        <h3>${appointment.first_name} ${appointment.last_name}</h3>
        <p>Gender: ${appointment.gender}</p>
        <p>Address: ${appointment.address}, ${appointment.address_number}</p>
        <p>Phone: ${appointment.phone}</p>
        <p>Email: ${appointment.email}</p>
      `);
      console.log('Showing details for appointment:', appointment);
    }
  
    // Back to schedule
    $('#backToSchedule').on('click', function () {
      $('#dashboardContainer').show();
      $('#patientDetails').hide();
    });
  
    $('#searchInput').on('input', function () {
      const searchTerm = $(this).val().toLowerCase();
      const filteredAppointments = appointments.filter(appointment =>
        `${appointment.first_name} ${appointment.last_name}`.toLowerCase().includes(searchTerm) ||
        appointment.time.toLowerCase().includes(searchTerm)
      );
      loadPatientList(filteredAppointments);
      console.log('Search term:', searchTerm, 'Filtered appointments:', filteredAppointments);
    });
  
    // Initial load of patient data for the current date
    const initialDate = new Date().toISOString().split('T')[0]; // Get current date in YYYY-MM-DD format
    $('#datePicker').val(initialDate); // Set the date picker to the current date
    loadPatientData(initialDate);
  
    // Debugging: Check if the date picker container is shown
    if ($('.date-picker-container').length) {
      console.log('Date picker container is shown on the dashboard');
    } else {
      console.log('Date picker container is NOT shown on the dashboard');
    }
  });