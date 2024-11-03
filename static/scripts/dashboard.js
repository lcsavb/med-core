

$(document).ready(function () {
    // Display the current date
    const currentDate = new Date().toLocaleDateString();
    $('#currentDate').text(`Current Date: ${currentDate}`);

      // Define the patients variable in the correct scope
      let appointments = [];

      // Function to load patient data
      function loadPatientData() {
        $.ajax({
            url: 'http://0.0.0.0/api/appointments/',
            type: 'GET',
            data: {
                clinicId: 1,
                doctorId: 4,
                date: '2024-10-30',
            },
            success: function(response) {
                console.log('Data retrieved successfully:', response);
                appointments = response.appointments; // Assign the received data to the appointments variable
                loadPatientList(appointments);
            },
            error: function(_xhr, status, error) {
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
   
    loadPatientData();
});