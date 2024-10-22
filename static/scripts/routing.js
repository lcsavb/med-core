document.addEventListener("DOMContentLoaded", function () {
  // Function to load the page dynamically
  function loadPage(pageName, scriptName, cssName) {
    const mainContent = document.getElementById('main-content');
    const baseUrl = document.getElementById('base-url').textContent.trim(); // Get base URL from hidden div

    // If pageName is null or empty, use 'home' as the default
    if (!pageName) {
      pageName = 'home';
    }

    // Construct the full URL for the HTML file
    const pageUrl = baseUrl + pageName + '.html';

    // Fetch the HTML content dynamically
    fetch(pageUrl)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Page not found: " + pageUrl);
        }
        return response.text();
      })
      .then((html) => {
        // Inject the fetched HTML into the main content div
        mainContent.innerHTML = html;

        // Dynamically load the page-specific script and CSS, if provided
        if (cssName) {
          const cssUrl = baseUrl + 'styles/' + cssName;
          loadCSS(cssUrl);
        }
        if (scriptName) {
          const scriptUrl = baseUrl + 'scripts/' + scriptName;
          loadScript(scriptUrl);
        }
      })
      .catch((error) => {
        console.error("Error loading page:", error);
        mainContent.innerHTML = '<p>Error loading page content.</p>';
      });
  }

  // Function to dynamically load a script
  function loadScript(scriptUrl) {
    const existingScript = document.querySelector(`script[src="${scriptUrl}"]`);

    // If the script is already loaded, remove it first to reload
    if (existingScript) {
      existingScript.remove();
    }

    // Create and append the new script element
    const script = document.createElement('script');
    script.src = scriptUrl;
    script.defer = true;
    document.body.appendChild(script);
  }

  // Function to dynamically load CSS
  function loadCSS(cssUrl) {
    const existingCSS = document.querySelector(`link[href="${cssUrl}"]`);

    // If the CSS is already loaded, remove it first to reload
    if (existingCSS) {
      existingCSS.remove();
    }

    // Create and append the new CSS link element
    const link = document.createElement('link');
    link.href = cssUrl;
    link.rel = 'stylesheet';
    document.head.appendChild(link);
  }

  // Attach event listeners to all navigation links
  const navLinks = document.querySelectorAll('.nav-link');
  navLinks.forEach(link => {
    link.addEventListener('click', function (event) {
      event.preventDefault();  // Prevent default link behavior (page reload)

      // Get the page name from the data-page attribute
      const pageName = this.getAttribute('data-page');

      // Get the page-specific script name from the data-script attribute
      const scriptName = this.getAttribute('data-script');

      // Get the page-specific CSS name from the data-css attribute
      const cssName = this.getAttribute('data-css');

      // Load the corresponding page dynamically and its script and CSS
      loadPage(pageName, scriptName, cssName);

      // Update the browser's URL to reflect the navigation
      window.history.pushState({}, '', pageName);
    });
  });

  // Handle back/forward navigation in the browser
  window.addEventListener('popstate', function () {
    const pageName = window.location.pathname.substring(1) || 'home';
    loadPage(pageName, null, null);  // No specific script or CSS for back/forward navigation
  });

  // Load the initial page content based on the current URL
  const initialPage = window.location.pathname.substring(1) || 'home';
  loadPage(initialPage, null, null);
});
