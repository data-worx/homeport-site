# Architecture

How homeport-site is laid out today, and why it is cut this way. The binding
rules live in the *Architecture* section of
[`AGENTS.md`](../AGENTS.md#architecture).

## Projects

| Project | Role | May depend on |
|---|---|---|
| Hugo site | Builds the static website from `content/`, `layouts/` and the synced design files | the generated design files from data-worx/homeport, and its documentation at a release tag |

## Directory layout

```
.github/workflows/
  deploy.yml            builds a release tag and deploys it to GitHub Pages
assets/
  css/tokens.css        generated, from data-worx/homeport
  css/site.css          the page stylesheet
  icons/                generated: Lucide and Homeport icons, inlined
  images/               generated: lockups, hero illustration, architecture
                        diagram
  js/theme.js           the theme switch
  js/copy-markdown.js   Copy as Markdown on the documentation pages
content/                one page per language: <name>.en.md, <name>.de.md;
                        the start page keeps its sections in front matter
  docs/                 generated: the Homeport documentation of a release
                        tag, English only
  devlog/               dated posts on how Homeport is built, English only
i18n/                   UI strings, en.toml and de.toml
layouts/
  baseof.html           the page frame
  home.html             the start page
  home.llms.txt         /llms.txt: every documentation page's Markdown
  page.html             text pages: imprint, privacy policy
  docs/                 the documentation: section and page layouts in
                        HTML and Markdown, and render hooks for its links
                        and images
  devlog/               the devlog: the list of posts and a post
  _partials/            head, header, footer, logo, icon, the
                        documentation's navigation, source link, Copy as
                        Markdown button, link resolution and Markdown,
                        the date and byline of a devlog post
  _shortcodes/          imprint-address: the address from imprint.local.txt
scripts/
  sync-design.sh        pulls the generated design files
  sync-docs.sh          pulls the documentation from a Homeport tag
  check-site.sh         checks a built site: links resolve, nothing loads
                        from another host; check-site.test.sh tests it
static/                 generated: fonts with their OFL texts, favicons,
                        licence texts, the link-preview image; besides them
                        .well-known/security.txt
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
  in both languages. The devlog section is the exception: it lists the
  three newest posts, taken from the devlog itself, on the start page of
  both languages, so it has no text of its own but its heading in `i18n/`.
- **The documentation comes from a release tag.** An operator reads the
  documentation of the version they run, not of a `main` that is ahead of
  every release. `scripts/sync-docs.sh` copies the five reader directories
  of `docs/` from the tag into `content/docs/` and only reshapes what Hugo
  needs: the first heading becomes the title, `README.md` becomes
  `_index.md`, and each reader directory gets an index titled after its
  heading in `docs/README.md`. That README, `releasing.md` and every
  `AGENTS.md` are not rendered. `content/docs/_index.md` records the tag.
- **Problem type URIs lead to their page.** Homeport names its problem
  types `https://homeport.data-worx.de/problems/<name>`. `sync-docs.sh`
  gives every page under `reference/problems/` that path as an alias, and
  their index `/problems/`. GitHub Pages cannot redirect, so Hugo writes a
  page there that moves the browser on with a meta refresh;
  `layouts/alias.html` keeps that page's links on the site. The gate `site`
  checks that every problem page has its URI.
- **The documentation's links are resolved at build time.** Each synced
  document records its path in the tag as `source`. The link hook in
  `layouts/docs/_markup/` resolves a relative link against it: a rendered
  document gets its page, anything else in the repository its file on
  GitHub at the tag. A link into a reader directory that matches no page
  fails the build, so a rename upstream cannot leave a dead link here.
- **Every documentation page is also Markdown.** A reader working with an
  AI assistant needs the text, not the HTML around it. Hugo's `markdown`
  output format, set on `/docs/` by a cascade in `hugo.toml`, writes
  `index.md` next to each page: the title, the page's URL and the synced
  source. The source carries the relative links of the homeport repository,
  so `_partials/docs-markdown.html` rewrites every link and image to an
  absolute site URL, resolved by `_partials/docs-href.html` — the same
  partial the HTML link hook uses, so both resolve alike.
- **`/llms.txt` indexes that Markdown.** It lists every documentation page
  with the URL of its `index.md`, in the order of the navigation, a
  subsection's pages after it. It exists in English only, like the
  documentation. The gate `site` checks that every page has its Markdown,
  that none of it holds a relative link, and that every URL in `llms.txt`
  exists.
- **Copy as Markdown fetches from this site.** The button fetches the
  page's `index.md` and writes it to the clipboard; nothing goes to a third
  party, and there is no link that opens a page in an AI service. It needs
  script, so it stays hidden without JavaScript, and the Markdown is still
  at its URL. The clipboard write starts with the click and receives the
  Markdown once fetched, since Safari drops a write that starts later.
- **The documentation is English only.** It is written once, in English,
  upstream. The German header links to it with `hreflang="en"` rather than
  showing a translation that does not exist.
- **The devlog is English only.** Like the documentation, it is written
  once, for every reader of the project; the German header links to it
  with `hreflang="en"`. Each post carries a date and a byline in its front
  matter, and the list shows the newest first.
- **The devlog's feed is built by Hugo.** Hugo's own RSS template writes
  `/devlog/index.xml`; no feed service sees who subscribes. `hugo.toml`
  sets every kind to HTML only and gives the RSS output to the devlog's
  list page alone, through a cascade, so no other page grows a feed. The
  gate `site` checks that the feed lists every post.
- **Code blocks are not highlighted.** Hugo's highlighter writes fixed
  inline colours that would ignore the dark theme; plain `<pre><code>`
  takes the token colours.
- **The built site is checked, not only built.** The gate `site` builds the
  site as it is deployed and runs `scripts/check-site.sh` over it: every
  internal link and anchor resolves, and nothing the browser loads —
  scripts, stylesheets, images, style URLs — comes from another host. The
  check's own tests run first, so a check that stopped finding anything
  fails instead of passing.
- **Link previews are meta tags only.** Every page carries Open Graph tags
  and `twitter:card`, read by whoever fetches a shared link; the page
  itself loads nothing for them. The image is the kit's social preview,
  one for all pages and both languages, so it needs an absolute URL and
  stays in `static/`.
- **Script only where a feature needs it.** Pages work without
  JavaScript; a feature that cannot work without it, such as Copy as
  Markdown, brings its own script, served from this site and setting no
  cookies, and is loaded only on the pages that have the feature.
- **The theme switch only enhances.** Without JavaScript the page follows
  `prefers-color-scheme` and the switch stays hidden. With it, a few inline
  lines in `<head>` apply the stored choice before the first paint, and
  `theme.js` handles the switch and keeps the choice in `localStorage`.
- **The imprint address never enters the repository.** It is the
  maintainer's own postal address. Committed, it would stay in the history
  for good and fall under CC BY. The shortcode reads it at build time from
  the git-ignored `imprint.local.txt` and shows a sample address when the
  file does not exist, so a fresh clone and the gates work without it.
- **A release deploys, a merge does not.** A merge means a change is done,
  not that it should go out. The workflow runs on a tag `vX.Y.Z`, refuses a
  tag outside `main` or without its changelog section, and runs the gates
  on the tagged commit. This follows the release rules being written in
  raisr/devkit#28.
- **Deployed through Actions, never from a branch.** `deploy-pages` takes
  the build as an artifact, so the built HTML with the imprint address is
  never committed. The workflow writes the secret `IMPRINT_ADDRESS` to
  `imprint.local.txt` before the build and fails when it is empty, so the
  sample address cannot go live.
- **Only a release tag may deploy.** The `github-pages` environment allows
  tags matching `v*.*.*` and no branch, so the rule holds on GitHub's side
  too, not only in the workflow's trigger.
- **Dot directories are uploaded on purpose.** `upload-pages-artifact`
  drops files starting with a dot by default, which would leave out
  `.well-known/security.txt`; the workflow sets `include-hidden-files`.
- **Hugo is pinned and checked.** The workflow installs one Hugo version,
  verified against the release's checksums, and every action is pinned by
  commit SHA, so a build does not change because something upstream did.
- **`security.txt` expires.** RFC 9116 requires an `Expires` date, at most a
  year ahead. It has to be moved forward before it passes.
