// DOM references
const patientContainer = document.getElementById("patientContainer");
const dynamicContent = document.getElementById("dynamicContent");
const addPatientButton = document.getElementById("addPatientButton");

// Function to generate and display the form
function showPatientForm() {
  // Clear existing content
  patientContainer.style.display = "none";
  dynamicContent.innerHTML = "";

  // Create form container
  const formContainer = document.createElement("div");
  formContainer.classList.add("patient-form-container");
  formContainer.style.width = "100%";
  formContainer.style.height = "100vh";
  formContainer.style.backgroundColor = "#fff";
  formContainer.style.padding = "20px";

  // Add form elements
  formContainer.innerHTML = `
    <h1>Add New Patient</h1>
    <form id="patientForm">
      <label for="patientName">Patient Name:</label>
      <input type="text" id="patientName" name="patientName" required /><br><br>
      
      <label for="patientAnamnesis">Anamnesis:</label>
      <textarea id="patientAnamnesis" name="patientAnamnesis" required></textarea><br><br>

      <button type="submit">Submit</button>
      <button type="button" id="cancelFormButton">Cancel</button>
    </form>
  `;

  // Add form container to dynamic content area
  dynamicContent.appendChild(formContainer);

  // Event listener for form submission
  const form = document.getElementById("patientForm");
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const name = document.getElementById("patientName").value;
    const anamnesis = document.getElementById("patientAnamnesis").value;
    addPatient(name, anamnesis);
  });

  // Cancel button functionality
  const cancelFormButton = document.getElementById("cancelFormButton");
  cancelFormButton.addEventListener("click", () => {
    dynamicContent.innerHTML = "";
    patientContainer.style.display = "block";
  });
}

// Add new patient to the list
function addPatient(name, anamnesis) {
  const patientList = document.getElementById("patientList");
  const patientItem = document.createElement("div");
  patientItem.classList.add("patient-item");
  patientItem.innerHTML = `
    <span class="patient-name">${name}</span>
    <span class="patient-anamnesis">${anamnesis}</span>
  `;
  patientList.appendChild(patientItem);

  // Return to patient list view
  dynamicContent.innerHTML = "";
  patientContainer.style.display = "block";
}

// Event listener for "Add Patient" button
addPatientButton.addEventListener("click", showPatientForm);