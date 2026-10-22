# AGENTS.md — homeport-site

Binding rules for anyone working in this repository, human or agent.
**It prescribes, it does not describe** — explanatory prose belongs in `docs/`,
and this file links to it.

## Shared rules

These files come from [raisr/devkit](https://github.com/raisr/devkit) and are
updated by `/devkit-sync`. Do not edit them here; change them upstream.

The `@` lines below are imports, not links: they pull the file into the
session. Turning one into a Markdown link silently switches the rules off.

@AGENTS.core.md — rules that hold in every repository
@AGENTS.github.md — conventions for github

@AGENTS.local.md — personal, machine-specific, git-ignored; wins on conflicts.
It is imported the same way, and the import is simply ignored where the file
does not exist.

## Overview

The project website of [Homeport](https://github.com/data-worx/homeport),
built with Hugo and published through GitHub Pages at
`homeport.data-worx.de`. It explains the platform and its modules; the
product documentation lives in the homeport repository.

Two facts a newcomer gets wrong:

- **The design is not made here.** The design system lives in
  `data-worx/homeport` under `design/`. This repository only consumes its
  generated files.
- **The site keeps the product's promise.** Homeport never phones home, and
  neither does its website: no tracking, no analytics, no third-party
  requests at runtime.

## Tech stack

- Hugo, static output only. No server-side code.
- GitHub Pages for hosting, custom domain `homeport.data-worx.de`.
- Fonts, scripts and stylesheets are served from this site. No CDN, no
  external embeds, no cookies.
- Design files are pulled with `scripts/sync-design.sh` from the `main`
  branch of `data-worx/homeport`; what is on `main` applies. They are
  generated files: never edit them by hand, change them upstream and sync
  again. The script names every file it writes.
- The gates live in `.devkit/gates.sh`; run them with
  `bash .devkit/gates.sh`.

## Architecture

Not set yet. The Hugo layout is decided with the ticket that creates it.

## Licensing

- **Content** — everything under `content/` — is licensed under CC BY 4.0
  (`LICENSE-CONTENT`).
- **Everything else** — templates, styles, scripts, configuration — is
  licensed under MIT (`LICENSE`).
- **The names "Homeport" and "data-worx" and their logos** are not licensed
  under either, wherever they are stored.
- Third-party assets — fonts, icons — only under a licence compatible with
  both (MIT, Apache-2.0, BSD, ISC, SIL OFL).

## Domain terms

See the *Domain terms* of
[data-worx/homeport](https://github.com/data-worx/homeport/blob/main/AGENTS.md#domain-terms).
The site uses them in the same sense.

## Deviations from the shared rules

Rules from `AGENTS.core.md` or a stack pack that deliberately do not apply here.
Every row was decided once and is recorded in `devkit.lock.json`, so
`/devkit-sync` does not ask again until the upstream rule changes.

| Rule | Deviation | Why |
|---|---|---|
| — | none yet | — |
