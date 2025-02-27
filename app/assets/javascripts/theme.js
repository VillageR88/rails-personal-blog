// Initialize theme on page load
function initTheme() {
  const root = document.documentElement;
  const themeSwitch = document.getElementById("theme-switch");
  const themeIcon = themeSwitch ? themeSwitch.querySelector("img") : null;

  // Check localStorage for saved theme or use system preference
  const savedTheme = localStorage.getItem("theme");
  const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

  // Set initial theme based on saved preference or system preference
  if (savedTheme === "dark" || (!savedTheme && prefersDark)) {
    root.classList.add("dark");
    updateThemeIcon("dark", themeIcon);
  } else {
    root.classList.remove("dark");
    updateThemeIcon("light", themeIcon);
  }
}

// Toggle between light and dark themes
function toggleTheme() {
  const root = document.documentElement;
  const themeIcon = document.querySelector("#theme-switch img");

  const isDark = root.classList.toggle("dark");
  const newTheme = isDark ? "dark" : "light";

  // Save preference to localStorage
  localStorage.setItem("theme", newTheme);

  // Update icon
  updateThemeIcon(newTheme, themeIcon);
}

// Update moon/sun icon based on current theme
function updateThemeIcon(theme, iconElement) {
  if (!iconElement) return;

  // Use the preloaded asset paths from window.ASSETS
  const iconPath =
    theme === "dark" ? window.ASSETS.sunIcon : window.ASSETS.moonIcon;

  iconElement.src = iconPath;
  iconElement.alt =
    theme === "dark" ? "Switch to light mode" : "Switch to dark mode";
}

// Initialize theme when DOM is loaded
document.addEventListener("DOMContentLoaded", initTheme);
