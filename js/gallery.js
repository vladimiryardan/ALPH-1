/* Gallery lightbox: shows the clicked photo in a modal with prev/next navigation. */
document.addEventListener("DOMContentLoaded", function () {
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
