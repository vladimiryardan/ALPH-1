/*!
* Start Bootstrap - Modern Business v5.0.6 (https://startbootstrap.com/template-overviews/modern-business)
* Copyright 2013-2022 Start Bootstrap
* Licensed under MIT (https://github.com/StartBootstrap/startbootstrap-modern-business/blob/master/LICENSE)
*/
// This file is intentionally blank
// Use this file to add JavaScript to your project

/* floating contact button  */

  document.addEventListener("DOMContentLoaded", function () {
    const widget = document.getElementById("contactWidget");
    const toggle = document.getElementById("contactToggle");
    const popup = document.getElementById("contactPopup");

    if (!widget || !toggle || !popup) {
      console.error("Contact widget elements were not found.");
      return;
    }

    toggle.addEventListener("click", function (event) {
      event.stopPropagation();
      popup.classList.toggle("show");
    });

    popup.addEventListener("click", function (event) {
      event.stopPropagation();
    });

    document.addEventListener("click", function () {
      popup.classList.remove("show");
    });

    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        popup.classList.remove("show");
      }
    });
  });
