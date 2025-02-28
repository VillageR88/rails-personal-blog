document.addEventListener("DOMContentLoaded", () => {
  const emailInput = document.getElementById("email");
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.has("email")) {
    emailInput.classList.add("success");
  } else {
  }
});
