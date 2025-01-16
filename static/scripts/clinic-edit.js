$(document).ready(function () {
    console.log("Document loaded for Clinics Edit page");
  
    // Function to show the Add Clinic form
    function showClinicForm() {
      console.log("Displaying Add Clinic form");
  
      // Clear existing content
      $("#clinicsContainer").hide();
      $("#dynamicContent").html("");
  
      // Create form container
      const formContainer = document.createElement("div");
      formContainer.classList.add("clinic-form-container");
      formContainer.style.width = "100%";
      formContainer.style.height = "100vh";
      formContainer.style.backgroundColor = "#fff";
      formContainer.style.padding = "20px";
  
      // Add form elements
      formContainer.innerHTML = `
        <h2>Add New Clinic</h2>
        <form id="addClinicForm">
          <label for="name">Name:</label>
          <input type="text" id="name" name="name" required><br><br>
          
          <label for="address">Address:</label>
          <input type="text" id="address" name="address" required><br><br>
          
          <label for="addressNumber">Address Number:</label>
          <input type="text" id="addressNumber" name="addressNumber" required><br><br>
          
          <label for="addressComplement">Address Complement:</label>
          <input type="text" id="addressComplement" name="addressComplement"><br><br>
          
          <label for="zip">ZIP Code:</label>
          <input type="text" id="zip" name="zip" required><br><br>
          
          <label for="city">City:</label>
          <input type="text" id="city" name="city" required><br><br>
          
          <label for="state">State:</label>
          <input type="text" id="state" name="state" required><br><br>
          
          <label for="country">Country:</label>
          <input type="text" id="country" name="country" required><br><br>
          
          <label for="phone">Phone:</label>
          <input type="text" id="phone" name="phone" required><br><br>
          
          <label for="email">Email:</label>
          <input type="email" id="email" name="email" required><br><br>
          
          <label for="website">Website:</label>
          <input type="text" id="website" name="website"><br><br>
          
          <label for="clinicType">Clinic Type:</label>
          <input type="text" id="clinicType" name="clinicType"><br><br>
          
          <button type="submit" class="button-style">Submit</button>
          <button type="button" id="cancelFormButton" class="button-style">Cancel</button>
        </form>
      `;
  
      // Append form container to dynamic content
      $("#dynamicContent").append(formContainer).show();
  
      // Attach event listener for form submission
      $("#addClinicForm").on("submit", async function (event) {
        event.preventDefault(); // Prevent form from submitting the default way
        console.log("Add Clinic form submitted");
  
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
  
        const clinicData = {
          name: $("#name").val(),
          address: $("#address").val(),
          address_number: $("#addressNumber").val(),
          address_complement: $("#addressComplement").val(),
          zip: $("#zip").val(),
          city: $("#city").val(),
          state: $("#state").val(),
          country: $("#country").val(),
          phone: $("#phone").val(),
          email: $("#email").val(),
          website: $("#website").val(),
          clinic_type: $("#clinicType").val(),
          created_at: formatDate(new Date()),
          updated_at: formatDate(new Date())
        };
  
        console.log("Clinic Data:", clinicData);
  
        try {
          const response = await fetch("http://0.0.0.0/api/clinics", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(clinicData),
          });
  
          if (response.ok) {
            console.log("Clinic added successfully");
            // Optionally, you can refresh the clinic list or show a success message
            $("#dynamicContent").hide();
            $("#clinicsContainer").show();
            window.loadClinicList(); // Refresh the clinic list
          } else {
            console.error("Failed to add clinic");
            alert("Failed to add clinic. Please try again.");
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
        $("#clinicsContainer").show();
      });
    }
  
    // Attach click listener for Add Clinic button using event delegation
    $(document).on("click", "#addClinicButton", function () {
      console.log("Add Clinic button clicked");
      showClinicForm(); // Call the form display function
    });
  });