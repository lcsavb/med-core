document.addEventListener('DOMContentLoaded', function () {
    // Display the current date
    const currentDateElement = document.getElementById('currentDate');
    const currentDate = new Date().toLocaleDateString();
    currentDateElement.textContent = `Current Date: ${currentDate}`;

    // Sample data for patients
    const patients = [
        { id: 1, name: 'John Doe', time: '09:00 AM', anamnesis: 'Patient anamnesis details for John Doe.' },
        { id: 2, name: 'Jane Smith', time: '10:00 AM', anamnesis: 'Patient anamnesis details for Jane Smith.' },
        { id: 3, name: 'Alice Johnson', time: '11:00 AM', anamnesis: 'Patient anamnesis details for Alice Johnson.' }
    ];

    // Load the list of patients
    const patientListElement = document.getElementById('patientList');
    patients.forEach(patient => {
        const patientItem = document.createElement('div');
        patientItem.className = 'patient-item';
        patientItem.textContent = `${patient.time} - ${patient.name}`;
        patientItem.addEventListener('click', () => showPatientDetails(patient));
        patientListElement.appendChild(patientItem);
    });

    // Show patient details
    function showPatientDetails(patient) {
        document.getElementById('dashboardContainer').style.display = 'none';
        document.getElementById('patientDetails').style.display = 'block';
        document.getElementById('anamnesisContent').textContent = patient.anamnesis;
    }

    // Back to schedule
    document.getElementById('backToSchedule').addEventListener('click', function () {
        document.getElementById('dashboardContainer').style.display = 'block';
        document.getElementById('patientDetails').style.display = 'none';
    });
});