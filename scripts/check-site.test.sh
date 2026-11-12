#!/usr/bin/env bash
# Tests for scripts/check-site.sh: each case builds a tiny site and states
# whether the check accepts it.
#
# Usage:  bash scripts/check-site.test.sh
set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT
failed=0

# A site of two pages that passes: links by path, by directory, relative,
# to an anchor, to another host, and a local stylesheet.
base() {
  local site="$1"
  mkdir -p "${site}/docs/a" "${site}/css"
  printf '%s\n' '<link rel="stylesheet" href="/css/site.css"><h2 id="top">Top</h2>' \
    '<a href="/docs/a/">a</a> <a href=/docs/a/#part>a part</a> <a href="#top">top</a>' \
    '<a href="https://example.org/">elsewhere</a> <a href="mailto:x@example.org">mail</a>' \
    > "${site}/index.html"
  printf '%s\n' '<p id=part>Part</p><a href="../../index.html">home</a><img src="/css/x.svg" alt="">' \
    > "${site}/docs/a/index.html"
  printf '%s\n' 'body { background: url(/css/x.svg); }' > "${site}/css/site.css"
  printf '%s\n' '<svg xmlns="http://www.w3.org/2000/svg"></svg>' > "${site}/css/x.svg"
}

# expect <pass|fail> <name> <html appended to the start page, or empty> [css]
expect() {
  local want="$1" name="$2" html="$3" css="${4:-}" site got
  site="${work}/${name// /-}"
  base "${site}"
  [ -n "${html}" ] && printf '%s\n' "${html}" >> "${site}/index.html"
  [ -n "${css}" ] && printf '%s\n' "${css}" >> "${site}/css/site.css"
  if bash scripts/check-site.sh "${site}" > "${site}.log" 2>&1; then got=pass; else got=fail; fi
  if [ "${got}" = "${want}" ]; then
    echo "ok   ${name}"
  else
    echo "FAIL ${name}: expected ${want}, got ${got}"
    sed 's/^/     /' "${site}.log"
    failed=1
  fi
}

expect pass "a sound site passes" ""
expect fail "a link to a missing page fails" '<a href="/docs/b/">b</a>'
expect fail "a relative link to a missing file fails" '<a href="docs/a/missing.html">m</a>'
expect fail "a link to a missing anchor fails" '<a href="/docs/a/#nowhere">n</a>'
expect fail "an image from another host fails" '<img src="https://cdn.example.org/x.png" alt="">'
expect fail "a protocol-relative script fails" '<script src="//cdn.example.org/x.js"></script>'
expect fail "a stylesheet from another host fails" '<link rel="stylesheet" href="https://fonts.example.org/x.css">'
expect fail "a srcset from another host fails" '<img src="/css/x.svg" srcset="https://cdn.example.org/x.png 2x" alt="">'
expect fail "a style url from another host fails" "" 'h1 { background: url(https://cdn.example.org/x.png); }'
expect fail "an import from another host fails" "" '@import "https://fonts.example.org/x.css";'

exit "${failed}"
