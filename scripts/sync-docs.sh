#!/usr/bin/env bash
# Pulls Homeport's documentation from a release tag of data-worx/homeport into
# content/docs/, so the site shows the documentation of a released version.
# The files it writes are generated: never edit them here.
#
# Usage:  bash scripts/sync-docs.sh vX.Y.Z
#
# HOMEPORT_REPO overrides the source, e.g. a local clone for offline work.
#
# What it does to the files, and nothing else:
# - copies the reader directories named in READERS, leaving out AGENTS*.md;
#   docs/README.md and docs/releasing.md are not rendered
# - turns every README.md into the _index.md of its directory
# - moves the first "# " heading into the front matter as the title, orders
#   each document as docs/README.md lists it, and records its path in the
#   tag as "source", which the link hook resolves relative links against
# - writes an _index.md for each reader directory, titled after its heading
#   in docs/README.md, and one for /docs/ that records the tag
set -euo pipefail

readonly READERS="operators module-developers api-consumers architecture reference"
readonly TARGET="content/docs"

tag="${1:-}"
if [[ ! "${tag}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "usage: bash scripts/sync-docs.sh vX.Y.Z - a release tag, not a candidate" >&2
  exit 2
fi

repo="${HOMEPORT_REPO:-https://github.com/data-worx/homeport.git}"

cd "$(git rev-parse --show-toplevel)"

src="$(mktemp -d)"
trap 'rm -rf "${src}"' EXIT

git -C "${src}" init -q
git -C "${src}" fetch -q --depth 1 "${repo}" "refs/tags/${tag}"
git -C "${src}" sparse-checkout set docs
git -C "${src}" checkout -q FETCH_HEAD
sha="$(git -C "${src}" rev-parse HEAD)"
d="${src}/docs"

# The order of docs/README.md: "path<TAB>weight" for every document it lists,
# and "@dir<TAB>weight<TAB>title<TAB>description" for every reader directory,
# taken from the "## Title — description" heading above its first row.
order="${src}/order.tsv"
awk -v readers=" ${READERS} " '
  /^## / {
    heading = substr($0, 4)
    split(heading, parts, " — ")
    title = parts[1]; desc = parts[2]
    next
  }
  /^\| \[/ {
    if (!match($0, /\]\([^)]+\)/)) next
    path = substr($0, RSTART + 2, RLENGTH - 3)
    print path "\t" ++row
    dir = path; sub(/\/.*/, "", dir)
    if (index(readers, " " dir " ") && !(dir in seen)) {
      seen[dir] = 1
      print "@" dir "\t" ++section "\t" title "\t" desc
    }
  }
' "${d}/README.md" > "${order}"

# Quotes a value for a single-quoted YAML scalar.
yaml() { printf "'%s'" "${1//\'/\'\'}"; }

# Writes a document: front matter with title and weight, then the body
# without its first "# " heading.
write_doc() {
  local from="$1" to="$2" rel="$3" title weight
  title="$(grep -m1 '^# ' "${from}" | sed 's/^# //')"
  if [ -z "${title}" ]; then
    echo "no '# ' heading in docs/${rel}" >&2
    exit 1
  fi
  weight="$(awk -F'\t' -v p="${rel}" '$1 == p { print $2 }' "${order}")"
  {
    echo "---"
    echo "title: $(yaml "${title}")"
    [ -n "${weight}" ] && echo "weight: ${weight}"
    echo "source: 'docs/${rel}'"
    echo "---"
    awk 'done || !/^# / { print; next } { done = 1; getline; if ($0 != "") print }' "${from}"
  } > "${to}"
}

rm -rf "${TARGET}"
mkdir -p "${TARGET}"

{
  echo "---"
  echo "title: 'Documentation'"
  echo "homeportVersion: '${tag}'"
  echo "---"
} > "${TARGET}/_index.md"
echo "${TARGET}/_index.md"

for reader in ${READERS}; do
  line="$(awk -F'\t' -v k="@${reader}" '$1 == k' "${order}")"
  if [ -z "${line}" ]; then
    echo "docs/README.md lists no document under ${reader}/" >&2
    exit 1
  fi
  IFS=$'\t' read -r _ weight title desc <<< "${line}"
  mkdir -p "${TARGET}/${reader}"
  {
    echo "---"
    echo "title: $(yaml "${title}")"
    echo "description: $(yaml "${desc}")"
    echo "weight: ${weight}"
    echo "---"
  } > "${TARGET}/${reader}/_index.md"
  echo "${TARGET}/${reader}/_index.md"

  while IFS= read -r -d '' file; do
    rel="${file#"${d}/"}"
    case "$(basename "${rel}")" in
      AGENTS*.md) continue ;;
    esac
    out="${TARGET}/${rel}"
    if [ "$(basename "${rel}")" = "README.md" ]; then
      out="$(dirname "${out}")/_index.md"
    fi
    mkdir -p "$(dirname "${out}")"
    case "${rel}" in
      *.md) write_doc "${file}" "${out}" "${rel}" ;;
      *)    cp "${file}" "${out}" ;;
    esac
    echo "${out}"
  done < <(find "${d}/${reader}" -type f -print0 | sort -z)
done

echo "synced docs from homeport ${tag} at ${sha}"
