$(document).ready(function () {
  console.log("Document loaded for Patients page");

  // References to elements
  const patientListContainer = document.getElementById("patientContainer");
  const patientDetailsContainer = document.getElementById("patientDetails");
  const patientFormContainer = document.getElementById("patientForm");

  const searchInput = document.getElementById("searchInput");
  const addPatientButton = document.getElementById("addPatientButton");
  const backToListButton = document.getElementById("backToList");

  // Function to load and display the patient list
  async function loadPatientList() {
    console.log("Loading patient list");

    try {
      const response = await fetch("http://127.0.0.1/api/patients?clinic_id=3", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (response.ok) {
        const data = await response.json();
        const patients = data.patients;
        console.log("Patients loaded successfully", patients);

        // Display the patient list
        const patientList = document.getElementById("patientList");
        patientList.innerHTML = ""; // Clear existing list

        patients.forEach((patient) => {
          const patientItem = document.createElement("div");
          patientItem.classList.add("patient-item");
          patientItem.dataset.id = patient.id;
          patientItem.innerHTML = `
            <span class="patient-name">${patient.first_name} ${patient.last_name}</span>
            <span class="patient-anamnesis">${patient.anamnesis}</span>
          `;
          patientItem.addEventListener("click", () => showPatientDetails(patient));
          patientList.appendChild(patientItem);
        });
      } else {
        console.error("Failed to load patients");
        alert("Failed to load patients. Please try again.");
      }
    } catch (error) {
      console.error("Error:", error);
      alert("An error occurred. Please try again.");
    }
  }

  // Load the patient list on page load
  loadPatientList();

  // Show patient details dynamically
  function showPatientDetails(patient) {
    patientDetailsContainer.style.display = "block";
    patientListContainer.style.display = "none";

    const anamnesisContent = document.getElementById("anamnesisContent");
    anamnesisContent.innerHTML = `
      <p><strong>Name:</strong> ${patient.first_name} ${patient.last_name}</p>
      <p><strong>Anamnesis:</strong> ${patient.anamnesis}</p>
    `;
  }

  // Attach event listener for search input
  searchInput.addEventListener("input", (event) => {
    loadPatientList(event.target.value);
  });

  // Attach event listener for back to list button
  if (backToListButton) {
    backToListButton.addEventListener("click", () => {
      patientDetailsContainer.style.display = "none";
      patientListContainer.style.display = "block";
    });
  }

  // Make loadPatientList accessible globally
  window.loadPatientList = loadPatientList;
});