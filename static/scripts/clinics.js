function initializeClinics() {
    // Define the clinics variable in the correct scope
    let clinics = [];
  
    // Function to load clinic data
    function loadClinicData() {
      $.ajax({
        url: 'http://0.0.0.0/api/clinics/',
        type: 'GET',
        success: function (response) {
          console.log('Data retrieved successfully:', response);
          clinics = response.clinics; // Assign the received data to the clinics variable
          loadClinicList(clinics);
        },
        error: function (_xhr, status, error) {
          console.error('Error fetching data:', status, error);
        }
      });
    }
  
    // Load the list of clinics
    const clinicListElement = $('#clinicList');
    function loadClinicList(filteredClinics) {
      clinicListElement.empty();
      filteredClinics.forEach(clinic => {
        const clinicName = clinic.name;
        const clinicLocation = clinic.location;
        const clinicItem = $('<div></div>')
          .addClass('clinic-item')
          .html(`
            <span class="clinic-name">${clinicName}</span>
            <span class="clinic-location">${clinicLocation}</span>
          `)
          .on('click', () => showClinicDetails(clinic));
        clinicListElement.append(clinicItem);
      });
      console.log('Clinic list loaded:', filteredClinics);
    }
  
    // Show clinic details
    function showClinicDetails(clinic) {
      $('#clinicsContainer').hide();
      $('#clinicDetails').show();
      $('#clinicDetailsContent').html(`
        <h3>${clinic.name}</h3>
        <p>Location: ${clinic.location}</p>
        <p>Contact: ${clinic.contact}</p>
      `);
      console.log('Showing details for clinic:', clinic);
    }
  
    // Back to clinics
    $('#backToClinics').on('click', function () {
      $('#clinicsContainer').show();
      $('#clinicDetails').hide();
    });
  
    $('#searchInput').on('input', function () {
      const searchTerm = $(this).val().toLowerCase();
      const filteredClinics = clinics.filter(clinic =>
        clinic.name.toLowerCase().includes(searchTerm) ||
        clinic.location.toLowerCase().includes(searchTerm)
      );
      loadClinicList(filteredClinics);
      console.log('Search term:', searchTerm, 'Filtered clinics:', filteredClinics);
    });
  
    // Initial load of clinic data
    loadClinicData();
  }