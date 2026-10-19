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

# Expectation per gate, printed when a gate fails.
gate_expectation() {
  case "$1" in
    build) echo "the site builds without warnings or errors" ;;
  esac
}

# --- runner, do not edit below unless you know why ---------------------------

GATES="build"

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
