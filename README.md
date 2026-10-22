# homeport-site

The project website of [Homeport](https://github.com/data-worx/homeport), the
self-hosted platform for deep business modules. Published at
[homeport.data-worx.de](https://homeport.data-worx.de).

## Status

A Hugo site with the start page in English and German. It builds, but it is
not published yet — publishing follows with the imprint and privacy pages
(see [ROADMAP.md](ROADMAP.md)).

## Working on it

The rules are in [AGENTS.md](AGENTS.md), the layout in
[docs/architecture.md](docs/architecture.md). You need
[Hugo](https://gohugo.io/) 0.158 or later.

Preview the site at `http://localhost:1313/`:

```bash
hugo server
```

Before a commit, run the gates:

```bash
bash .devkit/gates.sh
```

The design tokens, fonts, logos and the hero illustration are generated in
[data-worx/homeport](https://github.com/data-worx/homeport/tree/main/design).
Pull the current state of its `main` branch with:

```bash
bash scripts/sync-design.sh
```

The imprint and privacy pages show a sample address. To see the real one
locally, put it into `imprint.local.txt` in the repository root, one line per
address line. The file is git-ignored and never committed.

## Licence

| What | Licence |
|---|---|
| Content — everything under `content/` | [CC BY 4.0](LICENSE-CONTENT) |
| Everything else — templates, styles, scripts, configuration | [MIT](LICENSE) |
| Design tokens, illustrations and `hp-*` icons from data-worx/homeport — `assets/css/tokens.css`, `assets/images/hero-home-port.svg`, `assets/images/architecture-*.svg`, `assets/icons/hp-*.svg` | [AGPL-3.0-or-later](https://github.com/data-worx/homeport/blob/main/LICENSE) |
| Fonts — Instrument Sans, JetBrains Mono in `static/fonts/` | SIL OFL 1.1, texts next to the fonts |
| Lucide icons — the other files in `assets/icons/` | ISC, text in `static/licenses/` |
| The names "Homeport" and "data-worx" and their logos | not licensed |
