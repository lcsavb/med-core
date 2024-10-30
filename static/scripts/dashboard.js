$(document).ready(function () {
    // Display the current date
    const currentDate = new Date().toLocaleDateString();
    $('#currentDate').text(`Current Date: ${currentDate}`);

    // Sample data for patients
    const patients = [
        { id: 1, name: 'John Doe', time: '09:00 AM', anamnesis: 'John Doe is a 45-year-old male with a history of hypertension and type 2 diabetes. He has been on medication for both conditions for the past 10 years. He underwent a coronary artery bypass surgery 5 years ago. He is currently taking metformin and lisinopril. He has no known allergies. His family history includes heart disease and diabetes. He smokes one pack of cigarettes per day and consumes alcohol occasionally.' },
        { id: 2, name: 'Jane Smith', time: '10:00 AM', anamnesis: 'Jane Smith is a 30-year-old female with a history of asthma and seasonal allergies. She uses an inhaler as needed and takes antihistamines during allergy season. She has no history of surgeries. She is allergic to penicillin. Her family history includes asthma and allergies. She exercises regularly and follows a balanced diet.' },
        { id: 3, name: 'Alice Johnson', time: '11:00 AM', anamnesis: 'Alice Johnson is a 60-year-old female with a history of osteoarthritis and hypothyroidism. She has been on levothyroxine for the past 15 years. She underwent knee replacement surgery 2 years ago. She is currently taking ibuprofen for pain management. She has no known allergies. Her family history includes arthritis and thyroid disorders. She practices yoga and follows a low-sodium diet.' },
        { id: 4, name: 'Michael Brown', time: '12:00 PM', anamnesis: 'Michael Brown is a 50-year-old male with a history of chronic back pain and high cholesterol. He has been on statins for the past 5 years. He underwent spinal fusion surgery 3 years ago. He is currently taking atorvastatin and ibuprofen. He has no known allergies. His family history includes high cholesterol and back problems. He enjoys swimming and follows a low-fat diet.' },
        { id: 5, name: 'Emily Davis', time: '01:00 PM', anamnesis: 'Emily Davis is a 35-year-old female with a history of migraines and anxiety. She has been on medication for both conditions for the past 7 years. She has no history of surgeries. She is currently taking sumatriptan and sertraline. She has no known allergies. Her family history includes migraines and anxiety. She practices meditation and follows a gluten-free diet.' },
        { id: 6, name: 'David Wilson', time: '02:00 PM', anamnesis: 'David Wilson is a 40-year-old male with a history of peptic ulcer disease and seasonal allergies. He has been on medication for both conditions for the past 10 years. He underwent endoscopic treatment for ulcers 5 years ago. He is currently taking omeprazole and loratadine. He is allergic to peanuts. His family history includes peptic ulcers and allergies. He enjoys running and follows a high-fiber diet.' },
        { id: 7, name: 'Sarah Miller', time: '03:00 PM', anamnesis: 'Sarah Miller is a 28-year-old female with a history of polycystic ovary syndrome (PCOS) and depression. She has been on medication for both conditions for the past 3 years. She has no history of surgeries. She is currently taking metformin and fluoxetine. She has no known allergies. Her family history includes PCOS and depression. She practices yoga and follows a low-carb diet.' },
        { id: 8, name: 'James Taylor', time: '04:00 PM', anamnesis: 'James Taylor is a 55-year-old male with a history of chronic obstructive pulmonary disease (COPD) and hypertension. He has been on medication for both conditions for the past 8 years. He underwent lung volume reduction surgery 2 years ago. He is currently taking albuterol and amlodipine. He has no known allergies. His family history includes COPD and hypertension. He enjoys walking and follows a low-sodium diet.' },
        { id: 9, name: 'Laura Anderson', time: '05:00 PM', anamnesis: 'Laura Anderson is a 65-year-old female with a history of osteoporosis and type 2 diabetes. She has been on medication for both conditions for the past 12 years. She underwent hip replacement surgery 4 years ago. She is currently taking alendronate and metformin. She has no known allergies. Her family history includes osteoporosis and diabetes. She practices tai chi and follows a calcium-rich diet.' },
        { id: 10, name: 'Robert Thomas', time: '06:00 PM', anamnesis: 'Robert Thomas is a 70-year-old male with a history of prostate cancer and high cholesterol. He has been on medication for high cholesterol for the past 15 years. He underwent prostatectomy 10 years ago. He is currently taking atorvastatin. He has no known allergies. His family history includes prostate cancer and high cholesterol. He enjoys gardening and follows a low-fat diet.' },
        { id: 11, name: 'Linda Jackson', time: '07:00 PM', anamnesis: 'Linda Jackson is a 50-year-old female with a history of rheumatoid arthritis and hypertension. She has been on medication for both conditions for the past 20 years. She underwent joint replacement surgery 5 years ago. She is currently taking methotrexate and lisinopril. She is allergic to shellfish. Her family history includes rheumatoid arthritis and hypertension. She practices swimming and follows an anti-inflammatory diet.' },
        { id: 12, name: 'Charles White', time: '08:00 PM', anamnesis: 'Charles White is a 45-year-old male with a history of epilepsy and depression. He has been on medication for both conditions for the past 10 years. He has no history of surgeries. He is currently taking lamotrigine and sertraline. He has no known allergies. His family history includes epilepsy and depression. He enjoys cycling and follows a balanced diet.' },
        { id: 13, name: 'Barbara Harris', time: '09:00 PM', anamnesis: 'Barbara Harris is a 60-year-old female with a history of chronic kidney disease and hypertension. She has been on medication for both conditions for the past 15 years. She underwent kidney transplant 3 years ago. She is currently taking tacrolimus and amlodipine. She has no known allergies. Her family history includes kidney disease and hypertension. She practices yoga and follows a low-sodium diet.' },
        { id: 14, name: 'Paul Martin', time: '10:00 PM', anamnesis: 'Paul Martin is a 35-year-old male with a history of Crohn\'s disease and anxiety. He has been on medication for both conditions for the past 5 years. He underwent bowel resection surgery 2 years ago. He is currently taking infliximab and sertraline. He has no known allergies. His family history includes Crohn\'s disease and anxiety. He practices meditation and follows a low-fiber diet.' },
        { id: 15, name: 'Nancy Thompson', time: '11:00 PM', anamnesis: 'Nancy Thompson is a 40-year-old female with a history of multiple sclerosis (MS) and depression. She has been on medication for both conditions for the past 7 years. She has no history of surgeries. She is currently taking interferon beta-1a and fluoxetine. She has no known allergies. Her family history includes MS and depression. She practices tai chi and follows a low-fat diet.' }
    ];
    // Load the list of patients
    const patientListElement = $('#patientList');
    function loadPatientList(filteredPatients) {
        patientListElement.empty();
        filteredPatients.forEach(patient => {
            const patientItem = $('<div></div>')
                .addClass('patient-item')
                .html(`
                    <span class="patient-time">${patient.time}</span>
                    <span class="patient-name">${patient.name}</span>
                `)
                .on('click', () => showPatientDetails(patient));
            patientListElement.append(patientItem);
        });
    }
    loadPatientList(patients);

    // Show patient details
    function showPatientDetails(patient) {
        $('#dashboardContainer').hide();
        $('#patientDetails').show();
        $('#anamnesisContent').html(`
            <h3>${patient.name}</h3>
            <p>${patient.anamnesis}</p>
        `);
    }

    // Back to schedule
    $('#backToSchedule').on('click', function () {
        $('#dashboardContainer').show();
        $('#patientDetails').hide();
    });

    $('#searchInput').on('input', function () {
        const searchTerm = $(this).val().toLowerCase();
        const filteredPatients = patients.filter(patient => 
            patient.name.toLowerCase().includes(searchTerm) || 
            patient.time.toLowerCase().includes(searchTerm)
        );
        loadPatientList(filteredPatients);
    });
});