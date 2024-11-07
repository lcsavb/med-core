console.log('home.js loaded');
$(document).ready(function () {
  // Feature Items Intersection Observer
  const observerOptions = {
    threshold: 0.1 // Trigger when 10% of the item is visible
  };

  const observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        $(entry.target).addClass("visible");
        observer.unobserve(entry.target); // Stop observing once the item is visible
      }
    });
  }, observerOptions);

  $(".feature-item").each(function () {
    observer.observe(this);
  });
  $(".testimonial-item").each(function () {
    observer.observe(this);
  });

  // Testimonials Carousel
  const testimonials = $(".testimonial-item");
  let currentIndex = 0;

  function showTestimonial(index) {
    testimonials.removeClass("active next prev");
    testimonials.each(function (i) {
      if (i === index) {
        $(this).addClass("active");
      } else if (i === (index + 1) % testimonials.length) {
        $(this).addClass("next");
      } else if (i === (index - 1 + testimonials.length) % testimonials.length) {
        $(this).addClass("prev");
      }
    });
  }

  function showNextTestimonial() {
    currentIndex = (currentIndex + 1) % testimonials.length;
    showTestimonial(currentIndex);
  }

  // Auto-slide functionality
  setInterval(showNextTestimonial, 5000); // Change testimonial every 5 seconds

  // Initial display
  showTestimonial(currentIndex);

  // Intersection Observer for Hero Heading
  const heroHeading = $(".hero-heading")[0];
  if (heroHeading) observer.observe(heroHeading);

});
