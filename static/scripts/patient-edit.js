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

      <button type="submit" class="button-style">Submit</button>
      <button type="button" id="cancelFormButton" class="button-style">Back</button>
    </form>
  `;

  // Add form container to dynamic content area
dynamicContent.appendChild(formContainer);
console.log("Form container appended to dynamic content.");

// Event listener for form submission
const form = document.getElementById("patientForm");
console.log("Attaching event listener for form submission.");
form.addEventListener("submit", (e) => {
  e.preventDefault(); // Prevent default form submission
  const name = document.getElementById("patientName").value.trim();
  const anamnesis = document.getElementById("patientAnamnesis").value.trim();

  console.log("Form submitted with data:", { name, anamnesis });

  if (name === "" || anamnesis === "") {
    alert("All fields are required.");
    return;
  }

  console.log("Adding patient:", { name, anamnesis });
  addPatient(name, anamnesis);
});

  // Attach event listener to the dynamically created Back button
  const cancelFormButton = document.getElementById("cancelFormButton");
  cancelFormButton.addEventListener("click", () => {
    // Hide the form and return to the patient list
    dynamicContent.innerHTML = ""; // Clear the form
    patientContainer.style.display = "block"; // Show the patient list
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
  dynamicContent.innerHTML = ""; // Clear the form
  patientContainer.style.display = "block"; // Show the patient list
}

// Event listener for "Add Patient" button
addPatientButton.addEventListener("click", showPatientForm);