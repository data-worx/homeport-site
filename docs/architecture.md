# Architecture

How homeport-site is laid out today, and why it is cut this way. The binding
rules live in the *Architecture* section of
[`AGENTS.md`](../AGENTS.md#architecture).

## Projects

| Project | Role | May depend on |
|---|---|---|
| Hugo site | Builds the static website from `content/`, `layouts/` and the synced design files | the generated design files from data-worx/homeport |

## Directory layout

```
assets/
  css/tokens.css        generated, from data-worx/homeport
  css/site.css          the page stylesheet
  icons/                generated: Lucide and Homeport icons, inlined
  images/               generated: lockups, hero illustration, architecture
                        diagram
  js/theme.js           the theme switch, the only script
content/                one page per language: <name>.en.md, <name>.de.md;
                        the start page keeps its sections in front matter
i18n/                   UI strings, en.toml and de.toml
layouts/
  baseof.html           the page frame
  home.html             the start page
  page.html             text pages: imprint, privacy policy
  _partials/            head, header, footer, logo, icon
  _shortcodes/          imprint-address: the address from imprint.local.txt
scripts/sync-design.sh  pulls the generated design files
static/                 generated: fonts with their OFL texts, favicons,
                        licence texts
hugo.toml
imprint.local.txt       git-ignored: the imprint address, never committed
```

## Why it is cut this way

- **Own layouts, no theme.** A theme brings templates, scripts and often
  external requests the site would have to audit. Writing the few layouts
  keeps every request under control.
- **The design is synced, not written.** `scripts/sync-design.sh` copies the
  generated files from the `main` branch of data-worx/homeport, and they are
  committed here. The site's own history records which state was in use.
- **The stylesheet is one file.** Hugo concatenates `tokens.css` and
  `site.css`, minifies and fingerprints them; `tokens.css` loads the fonts
  from `../fonts/`, which resolves to `static/fonts/`.
- **The architecture diagram is inlined, without its own style.** The kit's
  files carry fixed light colours; the page drops their `<style>` and maps
  the class names to tokens, so the diagram follows the theme. A wide and a
  narrow variant are both in the page, CSS shows one. The labels inside stay
  English on the German page; the alternative text is translated.
- **The hero illustration is inlined.** Inline SVG lets its strokes take the
  token colours, so it follows the colour scheme. The alternative text comes
  from `i18n/`, because the file carries only an English one.
- **English at `/`, German at `/de/`.** English is the primary language;
  `disableDefaultLanguageRedirect` keeps Hugo from writing a redirect page
  under `/en/`.
- **Icons are inlined, not loaded.** `_partials/icon.html` puts the SVG into
  the page, so an icon takes the text colour and costs no request. The
  Lucide licence notice ships as `static/licenses/ISC-Lucide.txt`.
- **The start page's sections live in front matter.** Each section is a
  block of structured text in `content/_index.<lang>.md`; `home.html` lays
  them out. The text stays content under CC BY, the layout stays the same
  in both languages.
- **The theme switch only enhances.** Without JavaScript the page follows
  `prefers-color-scheme` and the switch stays hidden. With it, a few inline
  lines in `<head>` apply the stored choice before the first paint, and
  `theme.js` handles the switch and keeps the choice in `localStorage`.
- **The imprint address never enters the repository.** It is the
  maintainer's own postal address. Committed, it would stay in the history
  for good and fall under CC BY. The shortcode reads it at build time from
  the git-ignored `imprint.local.txt` and shows a sample address when the
  file does not exist, so a fresh clone and the gates work without it.
