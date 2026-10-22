// The theme switch. Without this script the page follows the colour scheme
// of the system and the switch stays hidden. The choice is kept in
// localStorage - no cookie, nothing leaves the browser.
(function () {
  var button = document.querySelector(".theme-switch");
  if (!button) return;
  var root = document.documentElement;
  var system = window.matchMedia("(prefers-color-scheme: dark)");

  function isDark() {
    var chosen = root.dataset.theme;
    return chosen ? chosen === "dark" : system.matches;
  }

  function sync() {
    button.setAttribute("aria-pressed", String(isDark()));
  }

  button.addEventListener("click", function () {
    var theme = isDark() ? "light" : "dark";
    root.dataset.theme = theme;
    try { localStorage.setItem("theme", theme); } catch (e) { /* private mode */ }
    sync();
  });
  system.addEventListener("change", sync);

  sync();
  button.hidden = false;
})();
