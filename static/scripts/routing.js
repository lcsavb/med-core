$(document).ready(function () {
  // Function to dynamically load the page, script, and CSS
  function loadPageResources(pageName, scriptName, cssName) {
    const mainContent = $('#main-content');
    const baseUrl = $('#base-url').text().trim(); // Get base URL from hidden div

    // If pageName is null or empty, use 'home' as the default
    if (!pageName) {
      pageName = 'home';
    }

    // Construct the full URL for the HTML file
    const pageUrl = baseUrl + pageName + '.html';

    // Fetch the HTML content dynamically using jQuery's $.ajax
    $.ajax({
      url: pageUrl,
      method: 'GET',
      success: function (html) {
        // Inject the fetched HTML into the main content div
        mainContent.html(html);

        // Dynamically load the page-specific script and CSS, if provided
        if (cssName) {
          const cssUrl = baseUrl + 'styles/' + cssName;
          loadCSS(cssUrl);
        }
        if (scriptName) {
          const scriptUrl = baseUrl + 'scripts/' + scriptName;
          loadScript(scriptUrl);
        }
      },
      error: function () {
        console.error("Error loading page:", pageUrl);
        mainContent.html('<p>Error loading page content.</p>');
      }
    });
  }

  // Function to dynamically load a script
  function loadScript(scriptUrl) {
    // Create and append the new script element
    $('<script>', {
      src: scriptUrl,
      defer: true
    }).appendTo('body');
  }

  // Function to dynamically load CSS
  function loadCSS(cssUrl) {
    // Create and append the new CSS link element
    $('<link>', {
      href: cssUrl,
      rel: 'stylesheet'
    }).appendTo('head');
  }

  // Attach event listeners to all navigation links
  $('.nav-link').on('click', function (event) {
    event.preventDefault();  // Prevent default link behavior (page reload)

    // Get the page name from the data-page attribute
    const pageName = $(this).data('page');

    // Get the page-specific script name from the data-script attribute
    const scriptName = $(this).data('script');

    // Get the page-specific CSS name from the data-css attribute
    const cssName = $(this).data('css');

    // Load the corresponding page, script, and CSS dynamically
    loadPageResources(pageName, scriptName, cssName);

    // Update the browser's URL to reflect the navigation
    window.history.pushState({}, '', pageName);
  });

  // Handle back/forward navigation in the browser
  $(window).on('popstate', function () {
    const pageName = window.location.pathname.substring(1) || 'home';
    const scriptName = `${pageName}.js`; // Generate script name for back/forward navigation
    const cssName = `${pageName}.css`;   // Generate CSS name for back/forward navigation
    loadPageResources(pageName, scriptName, cssName);
  });

  // Load the initial page content based on the current URL
  const initialPage = window.location.pathname.substring(1) || 'home';
  const initialScript = `${initialPage}.js`;  // Generate script name for initial load
  const initialCSS = `${initialPage}.css`;    // Generate CSS name for initial load
  loadPageResources(initialPage, initialScript, initialCSS);
});
