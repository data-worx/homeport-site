#!/usr/bin/env bash
# Pulls the generated design files from the main branch of data-worx/homeport
# into this site. What is on main is the design that applies.
#
# Usage:  bash scripts/sync-design.sh
#
# HOMEPORT_REPO overrides the source, e.g. a local clone for offline work.
set -euo pipefail

repo="${HOMEPORT_REPO:-https://github.com/data-worx/homeport.git}"

cd "$(git rev-parse --show-toplevel)"

src="$(mktemp -d)"
trap 'rm -rf "${src}"' EXIT

git -C "${src}" init -q
git -C "${src}" fetch -q --depth 1 "${repo}" main
git -C "${src}" sparse-checkout set design
git -C "${src}" checkout -q FETCH_HEAD
sha="$(git -C "${src}" rev-parse HEAD)"
d="${src}/design"

# <source under design/> <target in this repository>
while read -r from to; do
  mkdir -p "$(dirname "${to}")"
  cp "${d}/${from}" "${to}"
done <<'FILES'
dist/site-tokens.css                         assets/css/tokens.css
fonts/InstrumentSans-Variable.woff2          static/fonts/InstrumentSans-Variable.woff2
fonts/InstrumentSans-Variable-Italic.woff2   static/fonts/InstrumentSans-Variable-Italic.woff2
fonts/JetBrainsMono-Variable.woff2           static/fonts/JetBrainsMono-Variable.woff2
assets/licenses/OFL-InstrumentSans.txt       static/fonts/OFL-InstrumentSans.txt
assets/licenses/OFL-JetBrainsMono.txt        static/fonts/OFL-JetBrainsMono.txt
assets/logos/homeport-lockup.svg             assets/images/homeport-lockup.svg
assets/logos/homeport-lockup-on-dark.svg     assets/images/homeport-lockup-on-dark.svg
assets/illustrations/hero-home-port.svg      assets/images/hero-home-port.svg
assets/illustrations/architecture-horizontal.svg assets/images/architecture-horizontal.svg
assets/illustrations/architecture-vertical.svg   assets/images/architecture-vertical.svg
assets/logos/favicon.svg                     static/favicon.svg
assets/logos/favicon-16.png                  static/favicon-16.png
assets/logos/favicon-32.png                  static/favicon-32.png
assets/logos/homeport-icon-180.png           static/apple-touch-icon.png
assets/logos/homeport-icon-512.png           static/icon-512.png
assets/social/homeport-social-preview.png    static/images/homeport-social-preview.png
FILES

# Icons, inlined by layouts/_partials/icon.html. Lucide ships under ISC, whose
# notice travels with the site; the hp-* icons are part of Homeport.
mkdir -p assets/icons static/licenses
cp "${d}/assets/licenses/ISC-Lucide.txt" static/licenses/ISC-Lucide.txt
for icon in activity badge-check check download file-text git-branch layers \
            log-in moon receipt-text shield-check sun terminal; do
  cp "${d}/assets/icons/lucide/${icon}.svg" "assets/icons/${icon}.svg"
done
for icon in hp-module hp-quota; do
  cp "${d}/assets/icons/homeport/${icon}.svg" "assets/icons/${icon}.svg"
done

echo "synced design from homeport main at ${sha}"
