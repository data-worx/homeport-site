# homeport-site

The project website of [Homeport](https://github.com/data-worx/homeport), the
self-hosted platform for deep business modules. Published at
[homeport.data-worx.de](https://homeport.data-worx.de).

## Status

A Hugo site with the start page, the imprint and the privacy policy in
English and German, published on GitHub Pages from release tags (see
[ROADMAP.md](ROADMAP.md)).

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
address line, ending with the country — the site addresses readers abroad
as well. The file is git-ignored and never committed.

## Publishing

A merge to `main` does not publish anything. A release does:

1. Rename `## [Unreleased]` in `CHANGELOG.md` to `## [X.Y.Z] - YYYY-MM-DD`
   in a pull request, and merge it.
2. Tag the merge commit on `main` and push the tag:

   ```bash
   git switch main && git pull
   git tag vX.Y.Z
   git push origin vX.Y.Z
   ```

The workflow `.github/workflows/deploy.yml` then checks the tag, runs the
gates and deploys to GitHub Pages. To deploy an existing tag again, start it
by hand: `gh workflow run deploy.yml -f tag=vX.Y.Z`.

The repository's `github-pages` environment allows only tags matching
`v*.*.*` to deploy, no branch. GitHub creates it allowing `main` when Pages
is switched on; a tag deploy is then rejected until the rule is changed.

The workflow takes the imprint address from the repository secret
`IMPRINT_ADDRESS` and fails when it is empty. Set it from your local file,
so the address never passes through a terminal or a log:

```bash
gh secret set IMPRINT_ADDRESS < imprint.local.txt
```

In PowerShell, where `<` is not available:

```powershell
Get-Content imprint.local.txt -Raw | gh secret set IMPRINT_ADDRESS
```

## Licence

| What | Licence |
|---|---|
| Content — everything under `content/` | [CC BY 4.0](LICENSE-CONTENT) |
| Everything else — templates, styles, scripts, configuration | [MIT](LICENSE) |
| Design tokens, illustrations and `hp-*` icons from data-worx/homeport — `assets/css/tokens.css`, `assets/images/hero-home-port.svg`, `assets/images/architecture-*.svg`, `assets/icons/hp-*.svg` | [AGPL-3.0-or-later](https://github.com/data-worx/homeport/blob/main/LICENSE) |
| Fonts — Instrument Sans, JetBrains Mono in `static/fonts/` | SIL OFL 1.1, texts next to the fonts |
| Lucide icons — the other files in `assets/icons/` | ISC, text in `static/licenses/` |
| The names "Homeport" and "data-worx" and their logos, including the link-preview image `static/images/homeport-social-preview.png` | not licensed |
