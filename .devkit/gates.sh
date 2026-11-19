#!/usr/bin/env bash
# The gates that must be green before a commit. Project-owned: devkit-sync
# never overwrites this file, so adjust the commands to fit the repository.
#
# Usage:  bash .devkit/gates.sh [build|all]
#         (no argument means all)
set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

# Builds the site into a temporary directory, so the gate never leaves a
# public/ folder behind. Warnings fail the build: a broken reference or a
# missing template is a reason not to commit.
gate_build() {
  if [ ! -f hugo.toml ]; then
    echo "no hugo.toml - the Hugo site does not exist yet"
    return 77
  fi
  local out rc=0
  out="$(mktemp -d)"
  hugo build --gc --minify --panicOnWarning --destination "${out}" || rc=1
  rm -rf "${out}"
  return "${rc}"
}

# Builds the site as it is deployed and checks it: every internal link
# resolves and nothing loads from another host. The check's own tests run
# first, so a check that stopped finding anything cannot pass.
gate_site() {
  if [ ! -f hugo.toml ]; then
    echo "no hugo.toml - the Hugo site does not exist yet"
    return 77
  fi
  bash scripts/check-site.test.sh || return 1
  local out rc=0
  out="$(mktemp -d)"
  hugo build --gc --minify --destination "${out}" > /dev/null || rc=1
  [ "${rc}" -eq 0 ] && { bash scripts/check-site.sh "${out}" || rc=1; }
  [ "${rc}" -eq 0 ] && { check_problem_uris "${out}" || rc=1; }
  [ "${rc}" -eq 0 ] && { check_markdown "${out}" || rc=1; }
  [ "${rc}" -eq 0 ] && { check_devlog "${out}" || rc=1; }
  rm -rf "${out}"
  return "${rc}"
}

# Every problem type page answers at its type URI /problems/<name>/, and
# /problems/ at their index: the built site has a page there that leads to
# the documentation.
check_problem_uris() {
  local site="$1" docs="content/docs/reference/problems" page name rc=0
  for page in "${docs}"/*.md; do
    name="$(basename "${page}" .md)"
    if [ "${name}" = "_index" ]; then
      leads_to "${site}/problems/index.html" "/docs/reference/problems/" || rc=1
    else
      leads_to "${site}/problems/${name}/index.html" "/docs/reference/problems/${name}/" || rc=1
    fi
  done
  [ "${rc}" -eq 0 ] && echo "every problem type URI leads to its page"
  return "${rc}"
}

# Every documentation page has its Markdown next to it, with no relative
# link in it, and /llms.txt lists every one of them by a URL that exists.
check_markdown() {
  local site="$1" base html md url rc=0
  base="$(sed -n 's/^baseURL = "\(.*\)\/"$/\1/p' hugo.toml)"
  while IFS= read -r html; do
    md="${html%.html}.md"
    if [ ! -f "${md}" ]; then
      echo "${md#"${site}"/}: missing"
      rc=1
    elif ! grep -qF "](${base}${md#"${site}"})" "${site}/llms.txt"; then
      echo "${md#"${site}"/}: not in llms.txt"
      rc=1
    fi
  done < <(find "${site}/docs" -name index.html)
  # Inline links and images, and reference definitions.
  if grep -roE '\]\([^)]*\)|^ {0,3}\[[^]]+\]: *[^ ]+' --include=index.md "${site}/docs" \
      | grep -vE '(\]\(|\]: *)(https?|mailto):'; then
    echo "relative links in the Markdown of the documentation"
    rc=1
  fi
  while IFS= read -r url; do
    if [ ! -f "${site}${url#"${base}"}" ]; then
      echo "llms.txt: ${url} does not exist"
      rc=1
    fi
  done < <(grep -oE "\]\(${base}[^)]*\)" "${site}/llms.txt" | sed 's/^](//; s/)$//')
  [ "${rc}" -eq 0 ] && echo "every documentation page has its Markdown, listed in llms.txt"
  return "${rc}"
}

# The devlog has its RSS feed, and the feed lists every post by its URL.
check_devlog() {
  local site="$1" feed="$1/devlog/index.xml" base post rc=0
  base="$(sed -n 's/^baseURL = "\(.*\)\/"$/\1/p' hugo.toml)"
  if ! grep -q '<rss version="2.0"' "${feed}" 2> /dev/null; then
    echo "devlog/index.xml: missing or not an RSS feed"
    return 1
  fi
  for post in content/devlog/*.md; do
    [ "$(basename "${post}")" = "_index.md" ] && continue
    if ! grep -qF "<link>${base}/devlog/$(basename "${post}" .md)/</link>" "${feed}"; then
      echo "devlog/index.xml: does not list ${post}"
      rc=1
    fi
  done
  [ "${rc}" -eq 0 ] && echo "the devlog feed lists every post"
  return "${rc}"
}

leads_to() {
  if ! grep -q "url=$2\"" "$1" 2> /dev/null; then
    echo "$1: missing or does not lead to $2"
    return 1
  fi
}

# Expectation per gate, printed when a gate fails.
gate_expectation() {
  case "$1" in
    build) echo "the site builds without warnings or errors" ;;
    site)  echo "every internal link resolves, nothing loads from another host, every problem type URI leads to its page, every documentation page has its Markdown with absolute links, listed in llms.txt, the devlog feed lists every post" ;;
  esac
}

# --- runner, do not edit below unless you know why ---------------------------

GATES="build site"

# A gate returns 77 when it does not apply to this repository; its last line of
# output says why.
run_one() {
  local name="$1" log rc
  log="$(mktemp)"
  printf '=== %s ===\n' "${name}"
  "gate_${name}" > "${log}" 2>&1
  rc=$?
  if [ "${rc}" -eq 0 ]; then
    printf '  PASS\n'
    rm -f "${log}"
    return 0
  fi
  if [ "${rc}" -eq 77 ]; then
    printf '  SKIP - %s\n' "$(tail -n 1 "${log}")"
    rm -f "${log}"
    return 0
  fi
  printf '  FAIL - expected: %s\n' "$(gate_expectation "${name}")"
  tail -n 15 "${log}" | sed 's/^/    /'
  rm -f "${log}"
  return 1
}

main() {
  local want="${1:-all}" fail=0
  if [ "${want}" != "all" ]; then
    run_one "${want}"
    exit $?
  fi
  for g in ${GATES}; do
    run_one "${g}" || fail=1
    echo
  done
  if [ "${fail}" -eq 0 ]; then
    echo "GATES: all green"
  else
    echo "GATES: not ready"
  fi
  exit "${fail}"
}

main "$@"
