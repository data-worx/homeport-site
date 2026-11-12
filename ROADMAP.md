# Roadmap

Where homeport-site is going, in coarse phases. No dates, no estimates.
Each phase is broken into tickets when it is picked up — this file stays the
big picture, the tickets are the work.

Phases are ordered by dependency: a later phase assumes the earlier ones are
in place.

## M0 — Scaffold

Done — released in v0.1.0.

The Hugo site exists and builds from the Homeport design. It is not
published.

Done when:

1. `bash .devkit/gates.sh` runs the Hugo build instead of skipping it, and
   passes.
2. The site's styles use the design tokens from `design/` in
   data-worx/homeport, committed as generated files.
3. The built output makes no request to an external host.

Out of scope: publishing, imprint and privacy pages.

## M1 — Public launch

Done — released in v0.1.0.

The site is public under `homeport.data-worx.de`.

Done when:

1. The imprint and privacy pages are in place, in English and German. The
   imprint address is never committed: it comes from a local file and, on
   deploy, from a repository secret.
2. The site is published on GitHub Pages under `homeport.data-worx.de`, and
   HTTPS is enforced.

Out of scope: content beyond the start page and the quickstart.

## M2 — Homeport v0.1

Done — released in v0.3.0.

The site shows that Homeport v0.1 runs.

Done when:

1. The deploy publishes the stored release artifact and never builds.
2. The claim addresses the operator's IT.
3. The start page says what v0.1.0 does in the present tense, marks what is
   planned, and links the module poll in data-worx/homeport.
4. The Homeport documentation is rendered under `/docs/` from the tag
   `v0.1.0`.
5. The site is released with all of the above.

Out of scope: several documentation versions side by side, content for
Homeport v0.2.
