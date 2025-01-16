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
      const response = await fetch("http://0.0.0.0/api/patients?clinic_id=3", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          // Add Authorization header if required
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
      });
  
      // Check for non-200 responses
      if (!response.ok) {
        const errorText = await response.text();
        console.error(`Failed to load patients: ${response.status} - ${errorText}`);
        alert(`Error: ${response.status} - Failed to load patients.`);
        return;
      }
  
      const data = await response.json();
      const patients = data.patients || [];
      console.log("Patients loaded successfully:", patients);
  
      // Populate the patient list
      const $patientList = $("#patientList");
      $patientList.empty(); // Clear the existing list
  
      if (patients.length === 0) {
        $patientList.append("<p>No patients found.</p>");
        return;
      }
  
      patients.forEach((patient) => {
        const $patientItem = $(`
          <div class="patient-item" data-id="${patient.id}">
            <span class="patient-name">${patient.first_name} ${patient.last_name}</span>
            <span class="patient-anamnesis">${patient.anamnesis || "No anamnesis available"}</span>
          </div>
        `);
  
        // Add click event listener to show patient details
        $patientItem.on("click", () => showPatientDetails(patient));
  
        // Append the patient item to the list
        $patientList.append($patientItem);
      });
    } catch (error) {
      console.error("Error during GET request:", error);
      alert("An unexpected error occurred while loading patients. Please try again.");
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