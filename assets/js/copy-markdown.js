// Copy as Markdown on the documentation pages. Fetches the page's Markdown
// from this site and puts it on the clipboard. Without this script the
// button stays hidden; the Markdown is still served at index.md.
(function () {
  var box = document.querySelector(".doc-copy");
  if (!box || !navigator.clipboard) return;
  var button = box.querySelector("button");
  var label = box.querySelector(".doc-copy-label");
  var status = box.querySelector("[role=status]");
  var idle = label.textContent;
  var timer;

  function markdown() {
    return fetch(button.dataset.src).then(function (response) {
      if (!response.ok) throw new Error("HTTP " + response.status);
      return response.text();
    });
  }

  // Safari keeps the click only for a clipboard write that starts at once,
  // so the write gets the pending Markdown rather than waiting for it.
  function copy() {
    if (window.ClipboardItem && navigator.clipboard.write) {
      var blob = markdown().then(function (text) {
        return new Blob([text], { type: "text/plain" });
      });
      return navigator.clipboard.write([new ClipboardItem({ "text/plain": blob })]);
    }
    return markdown().then(function (text) {
      return navigator.clipboard.writeText(text);
    });
  }

  function show(text, done) {
    label.textContent = text;
    status.textContent = text;
    button.classList.toggle("is-done", done);
    clearTimeout(timer);
    timer = setTimeout(function () {
      label.textContent = idle;
      status.textContent = "";
      button.classList.remove("is-done");
    }, 2000);
  }

  button.addEventListener("click", function () {
    copy().then(
      function () { show(button.dataset.done, true); },
      function () { show(button.dataset.failed, false); }
    );
  });

  box.hidden = false;
})();
