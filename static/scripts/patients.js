function initializePatients() {
    // Define the patients variable in the correct scope
    let patients = [];
  
    // Function to load patient data
    function loadPatientData() {
      $.ajax({
        url: 'http://0.0.0.0/api/patients/',
        type: 'GET',
        success: function (response) {
          console.log('Data retrieved successfully:', response);
          patients = response.patients; // Assign the received data to the patients variable
          loadPatientList(patients);
        },
        error: function (_xhr, status, error) {
          console.error('Error fetching data:', status, error);
        }
      });
    }
  
    // Load the list of patients
    const patientListElement = $('#patientList');
    function loadPatientList(filteredPatients) {
      patientListElement.empty();
      filteredPatients.forEach(patient => {
        const patientName = `${patient.first_name} ${patient.last_name}`;
        const patientItem = $('<div></div>')
          .addClass('patient-item')
          .html(`
            <span class="patient-name">${patientName}</span>
          `)
          .on('click', () => showPatientDetails(patient));
        patientListElement.append(patientItem);
      });
      console.log('Patient list loaded:', filteredPatients);
    }
  
    // Show patient details
    function showPatientDetails(patient) {
      $('#patientsContainer').hide();
      $('#patientDetails').show();
      $('#patientDetailsContent').html(`
        <h3>${patient.first_name} ${patient.last_name}</h3>
        <p>Gender: ${patient.gender}</p>
        <p>Address: ${patient.address}, ${patient.address_number}</p>
        <p>Phone: ${patient.phone}</p>
        <p>Email: ${patient.email}</p>
      `);
      console.log('Showing details for patient:', patient);
    }
  
    // Back to patients
    $('#backToPatients').on('click', function () {
      $('#patientsContainer').show();
      $('#patientDetails').hide();
    });
  
    $('#searchInput').on('input', function () {
      const searchTerm = $(this).val().toLowerCase();
      const filteredPatients = patients.filter(patient =>
        `${patient.first_name} ${patient.last_name}`.toLowerCase().includes(searchTerm)
      );
      loadPatientList(filteredPatients);
      console.log('Search term:', searchTerm, 'Filtered patients:', filteredPatients);
    });
  
    // Initial load of patient data
    loadPatientData();
  }