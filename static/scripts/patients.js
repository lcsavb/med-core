// References to elements
const patientListContainer = document.getElementById("patientContainer");
const patientDetailsContainer = document.getElementById("patientDetails");
const patientFormContainer = document.getElementById("patientForm");

const searchInput = document.getElementById("searchInput");
const addPatientButton = document.getElementById("addPatientButton");
const backToListButton = document.getElementById("backToList");

// Patient data
const patients = [
  { id: 1, name: "John Doe", anamnesis: "General check-up" },
  { id: 2, name: "Jane Smith", anamnesis: "Flu symptoms" },
  { id: 3, name: "Alice Johnson", anamnesis: "Post-surgery recovery" },
];

// Render the patient list dynamically
function renderPatientList(filter = "") {
  const patientList = document.getElementById("patientList");
  patientList.innerHTML = ""; // Clear existing list

  // Filter and render patients
  patients
    .filter((p) => p.name.toLowerCase().includes(filter.toLowerCase()))
    .forEach((patient) => {
      const patientItem = document.createElement("div");
      patientItem.classList.add("patient-item");
      patientItem.dataset.id = patient.id;
      patientItem.innerHTML = `
        <span class="patient-name">${patient.name}</span>
        <span class="patient-anamnesis">${patient.anamnesis}</span>
      `;
      patientItem.addEventListener("click", () => showPatientDetails(patient));
      patientList.appendChild(patientItem);
    });
}

// Show patient details dynamically
function showPatientDetails(patient) {
  patientDetailsContainer.style.display = "block";
  patientListContainer.style.display = "none";

  const anamnesisContent = document.getElementById("anamnesisContent");
  anamnesisContent.innerHTML = `
    <p><strong>Name:</strong> ${patient.name}</p>
    <p><strong>Anamnesis:</strong> ${patient.anamnesis}</p>
  `;
}

// Show the Add/Edit Patient Form dynamically
function showPatientForm() {
  // Dynamically fetch and load the form content
  fetch("patient-edit.html")
    .then((response) => {
      if (!response.ok) {
        throw new Error("Failed to load the form");
      }
      return response.text();
    })
    .then((html) => {
      patientFormContainer.innerHTML = html; // Load the form into the container
      patientFormContainer.style.display = "block";
      patientListContainer.style.display = "none";
      patientDetailsContainer.style.display = "none";

      // Attach dynamic event listeners to the loaded form
      const cancelFormButton = document.getElementById("cancelFormButton");
      const patientFormContent = document.getElementById("patientFormContent");

      if (cancelFormButton) {
        cancelFormButton.addEventListener("click", hideForm);
      }

      if (patientFormContent) {
        patientFormContent.addEventListener("submit", addPatient);
      }
      if (backButton) {
        backButton.addEventListener("click", hideForm); // Return to the list without changes
      }
    })
    .catch((error) => console.error("Error loading the form:", error));
}

// Add or Edit a patient
function addPatient(e) {
  e.preventDefault();
  const firstName = document.getElementById("firstName").value.trim();
  const lastName = document.getElementById("lastName").value.trim();
  const anamnesis = document.getElementById("anamnesis").value.trim();

  if (!firstName || !lastName || !anamnesis) {
    alert("All fields are required!");
    return;
  }

  const newPatient = {
    id: patients.length + 1,
    name: `${firstName} ${lastName}`,
    anamnesis,
  };

  patients.push(newPatient);
  renderPatientList();
  hideForm();
}

// Hide the form and return to the list
function hideForm() {
  patientFormContainer.style.display = "none";
  patientListContainer.style.display = "block";
}

// Event listeners
addPatientButton.addEventListener("click", showPatientForm);

if (backToListButton) {
  backToListButton.addEventListener("click", () => {
    patientDetailsContainer.style.display = "none";
    patientListContainer.style.display = "block";
  });
}

searchInput.addEventListener("input", (e) => renderPatientList(e.target.value));

// Initial render of the patient list
renderPatientList();