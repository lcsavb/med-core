$(document).ready(function () {
  console.log("Document loaded for Clinics page");

  // References to elements
  const clinicsContainer = document.getElementById("clinicsContainer");
  const clinicDetailsContainer = document.getElementById("clinicDetails");
  const clinicListElement = document.getElementById("clinicList");
  const backToClinicsButton = document.getElementById("backToClinics");

  // Function to load and display the clinic list
  async function loadClinicList() {
    console.log("Loading clinic list");

    try {
      const response = await fetch("http://0.0.0.0/api/clinics", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${localStorage.getItem("token")}`,
        },
      });

      if (response.ok) {
        const data = await response.json();
        const clinics = data.clinics || [];
        console.log("Clinics loaded successfully:", clinics);

        // Display the clinic list
        clinicListElement.innerHTML = ""; // Clear existing list

        if (clinics.length === 0) {
          clinicListElement.innerHTML = "<p>No clinics found.</p>";
          return;
        }

        clinics.forEach((clinic) => {
          const clinicItem = document.createElement("div");
          clinicItem.classList.add("clinic-item");
          clinicItem.dataset.id = clinic.id;
          clinicItem.innerHTML = `
            <span class="clinic-name">${clinic.name}</span>
          `;
          clinicItem.addEventListener("click", () => showClinicDetails(clinic));
          clinicListElement.appendChild(clinicItem);
        });
      } else {
        const errorText = await response.text();
        console.error(`Failed to load clinics: ${response.status} - ${errorText}`);
        alert(`Error: ${response.status} - Failed to load clinics.`);
      }
    } catch (error) {
      console.error("Error during GET request:", error);
      alert("An unexpected error occurred while loading clinics. Please try again.");
    }
  }

  // Load the clinic list on page load
  loadClinicList();

  // Show clinic details dynamically
  function showClinicDetails(clinic) {
    clinicsContainer.style.display = "none";
    clinicDetailsContainer.style.display = "block";

    const clinicDetailsContent = document.getElementById("clinicDetailsContent");
    clinicDetailsContent.innerHTML = `
      <p><strong>Name:</strong> ${clinic.name}</p>
      <p><strong>Location:</strong> ${clinic.location}</p>
      <p><strong>Description:</strong> ${clinic.description}</p>
    `;
  }

  // Attach event listener for "Back to Clinics" button
  backToClinicsButton.addEventListener("click", function () {
    console.log("Back to Clinics button clicked");
    clinicDetailsContainer.style.display = "none";
    clinicsContainer.style.display = "block";
  });

  // Make loadClinicList accessible globally
  window.loadClinicList = loadClinicList;
});