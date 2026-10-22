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
  images/               generated: lockups and hero illustration
content/                one page per language: <name>.en.md, <name>.de.md
i18n/                   UI strings, en.toml and de.toml
layouts/
  baseof.html           the page frame
  home.html             the start page
  _partials/            head, header, footer, logo
scripts/sync-design.sh  pulls the generated design files
static/                 generated: fonts with their OFL texts, favicons
hugo.toml
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
- **The hero illustration is inlined.** Inline SVG lets its strokes take the
  token colours, so it follows the colour scheme. The alternative text comes
  from `i18n/`, because the file carries only an English one.
- **English at `/`, German at `/de/`.** English is the primary language;
  `disableDefaultLanguageRedirect` keeps Hugo from writing a redirect page
  under `/en/`.
