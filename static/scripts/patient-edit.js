$(document).ready(function () {
  console.log("Document loaded for Patients Edit page");

  // Function to show the Add Patient form
  function showPatientForm() {
    console.log("Displaying Add Patient form");

    // Clear existing content
    $("#patientContainer").hide();
    $("#dynamicContent").html("");

    // Create form container
    const formContainer = document.createElement("div");
    formContainer.classList.add("patient-form-container");
    formContainer.style.width = "100%";
    formContainer.style.height = "100vh";
    formContainer.style.backgroundColor = "#fff";
    formContainer.style.padding = "20px";

    // Add form elements
    formContainer.innerHTML = `
      <h2>Add New Patient</h2>
      <form id="addPatientForm">
        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName" required><br><br>
        
        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" required><br><br>
        
        <label for="picture">Picture (Base64):</label>
        <textarea id="picture" name="picture" required></textarea><br><br>
        
        <label for="dateOfBirth">Date of Birth:</label>
        <input type="date" id="dateOfBirth" name="dateOfBirth" required><br><br>
        
        <label for="gender">Gender:</label>
        <select id="gender" name="gender">
          <option value="male">Male</option>
          <option value="female">Female</option>
          <option value="other">Other</option>
        </select><br><br>
        
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" required><br><br>
        
        <label for="addressNumber">Address Number:</label>
        <input type="text" id="addressNumber" name="addressNumber" required><br><br>
        
        <label for="addressComplement">Address Complement:</label>
        <input type="text" id="addressComplement" name="addressComplement"><br><br>
        
        <label for="zip">ZIP Code:</label>
        <input type="text" id="zip" name="zip" required><br><br>
        
        <label for="phone">Phone:</label>
        <input type="text" id="phone" name="phone" required><br><br>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>
        
        <label for="status">Status:</label>
        <select id="status" name="status">
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
        </select><br><br>
        
        <label for="emergencyContactName">Emergency Contact Name:</label>
        <input type="text" id="emergencyContactName" name="emergencyContactName" required><br><br>
        
        <label for="emergencyContactPhone">Emergency Contact Phone:</label>
        <input type="text" id="emergencyContactPhone" name="emergencyContactPhone" required><br><br>
        
        <label for="nationality">Nationality:</label>
        <input type="text" id="nationality" name="nationality" required><br><br>
        
        <label for="language">Language:</label>
        <input type="text" id="language" name="language" required><br><br>
        
        <label for="insuranceProvider">Insurance Provider:</label>
        <input type="text" id="insuranceProvider" name="insuranceProvider" required><br><br>
        
        <label for="insurancePolicyNumber">Insurance Policy Number:</label>
        <input type="text" id="insurancePolicyNumber" name="insurancePolicyNumber" required><br><br>
        
        <button type="submit" class="button-style">Submit</button>
        <button type="button" id="cancelFormButton" class="button-style">Cancel</button>
      </form>
    `;

    // Append form container to dynamic content
    $("#dynamicContent").append(formContainer).show();

    // Attach event listener for form submission
    $("#addPatientForm").on("submit", async function (event) {
      event.preventDefault(); // Prevent form from submitting the default way
      console.log("Add Patient form submitted");

      const formatDate = (date) => {
        const d = new Date(date);
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        const hours = String(d.getHours()).padStart(2, '0');
        const minutes = String(d.getMinutes()).padStart(2, '0');
        const seconds = String(d.getSeconds()).padStart(2, '0');
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
      };

      const patientData = {
        first_name: $("#firstName").val(),
        last_name: $("#lastName").val(),
        picture: $("#picture").val(),
        date_of_birth: $("#dateOfBirth").val(),
        gender: $("#gender").val(),
        address: $("#address").val(),
        address_number: $("#addressNumber").val(),
        address_complement: $("#addressComplement").val(),
        zip: $("#zip").val(),
        phone: $("#phone").val(),
        email: $("#email").val(),
        status: $("#status").val(),
        emergency_contact_name: $("#emergencyContactName").val(),
        emergency_contact_phone: $("#emergencyContactPhone").val(),
        nationality: $("#nationality").val(),
        language: $("#language").val(),
        insurance_provider: $("#insuranceProvider").val(),
        insurance_policy_number: $("#insurancePolicyNumber").val(),
        created_at: formatDate(new Date()),
        updated_at: formatDate(new Date())
      };

      console.log("Patient Data:", patientData);

      try {
        const response = await fetch("http://0.0.0.0/api/patients", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(patientData),
        });

        if (response.ok) {
          console.log("Patient added successfully");
          // Optionally, you can refresh the patient list or show a success message
          $("#dynamicContent").hide();
          $("#patientContainer").show();
          window.loadPatientList(); // Refresh the patient list
        } else {
          console.error("Failed to add patient");
          alert("Failed to add patient. Please try again.");
        }
      } catch (error) {
        console.error("Error:", error);
        alert("An error occurred. Please try again.");
      }
    });

    // Attach event listener for cancel button
    $("#cancelFormButton").on("click", function () {
      console.log("Cancel button clicked");
      $("#dynamicContent").hide();
      $("#patientContainer").show();
    });
  }

  // Attach click listener for Add Patient button using event delegation
  $(document).on("click", "#addPatientButton", function () {
    console.log("Add Patient button clicked");
    showPatientForm(); // Call the form display function
  });
});