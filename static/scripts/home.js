document.addEventListener("DOMContentLoaded", function () {
    // Intersection Observer for Feature Items
    const featureItems = document.querySelectorAll(".feature-item");

    const observerOptions = {
      threshold: 0.1,
    };

    const observer = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("visible");
          observer.unobserve(entry.target);
        }
      });
    }, observerOptions);

    featureItems.forEach((item) => {
      observer.observe(item);
    });
  });
  document.addEventListener("DOMContentLoaded", function () {
    // Testimonials Carousel
    const testimonials = document.querySelectorAll(".testimonial-item");
    let currentIndex = 0;

    function showTestimonial(index) {
      testimonials.forEach((testimonial, i) => {
        testimonial.classList.remove("active", "next", "prev");
        if (i === index) {
          testimonial.classList.add("active");
        } else if (i === (index + 1) % testimonials.length) {
          testimonial.classList.add("next");
        } else if (
          i ===
          (index - 1 + testimonials.length) % testimonials.length
        ) {
          testimonial.classList.add("prev");
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

    // Intersection Observer for Hero Heading and Feature Items
    const heroHeading = document.querySelector(".hero-heading");
    const featureItems = document.querySelectorAll(".feature-item");

    const observerOptions = {
      threshold: 0.1,
    };

    const observer = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("visible");
          observer.unobserve(entry.target);
        }
      });
    }, observerOptions);

    observer.observe(heroHeading);
    featureItems.forEach((item) => {
      observer.observe(item);
    });
  });