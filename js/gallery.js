/* Load nearby gallery thumbnails and show photos in the lightbox. */
document.addEventListener("DOMContentLoaded", function () {
  const lazyImages = document.querySelectorAll(".gallery-thumb-img[data-src]");

  function loadThumbnail(image) {
    image.src = image.dataset.src;
    image.removeAttribute("data-src");
    image.hidden = false;
  }

  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        const image = entry.target.querySelector("img[data-src]");
        if (image) loadThumbnail(image);
        observer.unobserve(entry.target);
      });
    }, { rootMargin: "300px 0px" });

    // Observe the square link: hidden images have no layout box of their own.
    lazyImages.forEach(function (image) {
      observer.observe(image.parentElement);
    });
  } else {
    lazyImages.forEach(function (image) {
      image.loading = "lazy";
      loadThumbnail(image);
    });
  }

  const modalEl = document.getElementById("galleryModal");
  if (!modalEl) {
    return;
  }

  const modalImage = document.getElementById("galleryModalImage");
  const prevBtn = modalEl.querySelector(".gallery-nav-prev");
  const nextBtn = modalEl.querySelector(".gallery-nav-next");
  const albums = window.galleryAlbums || {};

  let currentAlbum = null;
  let currentIndex = 0;

  function showImage() {
    const images = albums[currentAlbum] || [];
    if (!images.length) {
      return;
    }
    currentIndex = (currentIndex + images.length) % images.length;
    modalImage.src = images[currentIndex];
    const thumbnail = Array.from(document.querySelectorAll(".gallery-thumb")).find(function (thumb) {
      return thumb.getAttribute("data-album") === currentAlbum &&
        Number(thumb.getAttribute("data-index")) === currentIndex;
    });
    const thumbnailImage = thumbnail ? thumbnail.querySelector("img") : null;
    modalImage.alt = thumbnailImage ? thumbnailImage.alt : "Attic ladder installation photo";
  }

  document.querySelectorAll(".gallery-thumb").forEach(function (thumb) {
    thumb.addEventListener("click", function (event) {
      event.preventDefault();
      currentAlbum = thumb.getAttribute("data-album");
      currentIndex = parseInt(thumb.getAttribute("data-index"), 10) || 0;
      showImage();
    });
  });

  prevBtn.addEventListener("click", function () {
    currentIndex -= 1;
    showImage();
  });

  nextBtn.addEventListener("click", function () {
    currentIndex += 1;
    showImage();
  });

  document.addEventListener("keydown", function (event) {
    if (!modalEl.classList.contains("show")) {
      return;
    }
    if (event.key === "ArrowLeft") {
      prevBtn.click();
    } else if (event.key === "ArrowRight") {
      nextBtn.click();
    }
  });
});
