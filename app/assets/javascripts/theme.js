const iconMoon = `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 18 18"><path stroke="#1C1A19" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15.913 9.664a5.556 5.556 0 1 1-7.577-7.577 6.945 6.945 0 1 0 7.577 7.577Z"/></svg>`;
const iconSun = `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 18 18"><path stroke="#FEFEFE" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 2.055v1.39m0 11.11v1.39M3.444 9H2.056M5.052 5.05l-.983-.982m8.88.982.982-.982m-8.88 8.882-.982.982m8.88-.982.982.982M15.945 9h-1.39m-2.083 0a3.472 3.472 0 1 1-6.944 0 3.472 3.472 0 0 1 6.944 0Z"/></svg>`;

function initTheme() {
  const root = document.documentElement;
  const themeSwitch = document.getElementById("theme-switch");

  if (!themeSwitch) return;

  const savedTheme = localStorage.getItem("theme");
  const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

  if (savedTheme === "dark" || (!savedTheme && prefersDark)) {
    root.classList.add("dark");
    updateThemeIcon("dark", themeSwitch);
  } else {
    root.classList.remove("dark");
    updateThemeIcon("light", themeSwitch);
  }
  document.body.classList.remove("hidden");
  document.body.classList.add("flex");
}

function toggleTheme() {
  const root = document.documentElement;
  const themeSwitch = document.getElementById("theme-switch");

  const isDark = root.classList.toggle("dark");
  const newTheme = isDark ? "dark" : "light";

  localStorage.setItem("theme", newTheme);

  updateThemeIcon(newTheme, themeSwitch);
}

function updateThemeIcon(theme, element) {
  if (!element) return;

  const iconSvg = theme === "dark" ? iconSun : iconMoon;

  element.innerHTML = iconSvg;
}

document.addEventListener("DOMContentLoaded", initTheme);
