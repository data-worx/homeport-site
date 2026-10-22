# Roadmap

Where homeport-site is going, in coarse phases. No dates, no estimates.
Each phase is broken into tickets when it is picked up — this file stays the
big picture, the tickets are the work.

Phases are ordered by dependency: a later phase assumes the earlier ones are
in place.

## M0 — Scaffold

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

The site is public under `homeport.data-worx.de`.

**Blocked by the imprint address.** The site does not go public without an
imprint, and no private address is published — M1 starts once the imprint
address service is booked.

Done when:

1. An imprint address exists that is not a private one.
2. The imprint and privacy pages are in place, in English and German.
3. The site is published on GitHub Pages under `homeport.data-worx.de`, and
   HTTPS is enforced.

Out of scope: content beyond the start page and the quickstart.
