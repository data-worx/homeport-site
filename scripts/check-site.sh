#!/usr/bin/env bash
# Checks a built site for the two promises a build alone does not keep:
# - every internal link and every loaded file resolves, anchors included
# - nothing the browser loads comes from another host
#
# Links to other hosts are not followed; a link is not a request.
# One awk pass does the work: a loop of shell commands per link takes
# minutes on Windows.
#
# Usage:  bash scripts/check-site.sh <built site directory>
set -euo pipefail

root="${1:?usage: bash scripts/check-site.sh <built site directory>}"
root="${root%/}"

files="$(mktemp)"
pages="$(mktemp)"
trap 'rm -f "${files}" "${pages}"' EXIT
find "${root}" -type f > "${files}"
find "${root}" -type f \( -name '*.html' -o -name '*.css' \) > "${pages}"

awk -v root="${root}" '
  # An attribute value without its quotes.
  function unquote(v) {
    if (v ~ /^["\047]/) v = substr(v, 2, length(v) - 2)
    return v
  }
  function external(u) { return u ~ /^([a-zA-Z][a-zA-Z0-9+.-]*:)?\/\// }
  function scheme(u)   { return u ~ /^[a-zA-Z][a-zA-Z0-9+.-]*:/ }
  function fail(file, msg) {
    sub("^" root "/", "", file)
    print file ": " msg
    failures++
  }
  # Resolves "." and ".." in a path.
  function normalize(p,    parts, n, i, out, k) {
    n = split(p, parts, "/")
    k = 0
    for (i = 1; i <= n; i++) {
      if (parts[i] == "." || (parts[i] == "" && i > 1)) continue
      if (parts[i] == ".." && k > 1) { k--; continue }
      out[++k] = parts[i]
    }
    p = out[1]
    for (i = 2; i <= k; i++) p = p "/" out[i]
    return p
  }

  # Records the ids, links and loaded files of one line of a page.
  function scan(file, text,    line, attr, eq, tag) {
    line = text
    while (match(line, /id=("[^"]*"|\047[^\047]*\047|[^"\047 >]+)/)) {
      ids[file, unquote(substr(line, RSTART + 3, RLENGTH - 3))] = 1
      line = substr(line, RSTART + RLENGTH)
    }

    # Stylesheets and inline styles: url() and @import stay on this site.
    if (file ~ /\.css$/ || text ~ /<style|style=/) {
      line = text
      while (match(line, /url\([^)]*\)|@import[^;]*/)) {
        if (substr(line, RSTART, RLENGTH) ~ /\/\//) fail(file, "a style loads from another host")
        line = substr(line, RSTART + RLENGTH)
      }
    }
    if (file ~ /\.css$/) return

    line = text
    while (match(line, /(href|src)=("[^"]*"|\047[^\047]*\047|[^"\047[:space:]>]+)/)) {
      attr = substr(line, RSTART, RLENGTH)
      line = substr(line, RSTART + RLENGTH)
      eq = index(attr, "=")
      n++
      lfile[n] = file
      lkind[n] = substr(attr, 1, eq - 1)
      lurl[n] = unquote(substr(attr, eq + 1))
    }

    # <link> elements load what they point at, stylesheets and icons alike.
    line = text
    while (match(line, /<link[^>]*>/)) {
      tag = substr(line, RSTART, RLENGTH)
      line = substr(line, RSTART + RLENGTH)
      if (match(tag, /href=("[^"]*"|\047[^\047]*\047|[^"\047[:space:]>]+)/) &&
          external(unquote(substr(tag, RSTART + 5, RLENGTH - 5))))
        fail(file, "loads from another host: " tag)
    }

    if (text ~ /srcset=[^>]*\/\//) fail(file, "srcset loads from another host")
  }

  FNR == NR { exists[$0] = 1; next }

  {
    page = $0
    while ((getline text < page) > 0) scan(page, text)
    close(page)
  }

  END {
    for (i = 1; i <= n; i++) {
      file = lfile[i]; url = lurl[i]
      if (external(url)) {
        if (lkind[i] == "src") fail(file, "loads from another host: " url)
        continue
      }
      if (scheme(url)) continue

      path = url; frag = ""
      if (index(path, "#")) { frag = substr(path, index(path, "#") + 1); path = substr(path, 1, index(path, "#") - 1) }
      if (index(path, "?")) path = substr(path, 1, index(path, "?") - 1)

      if (path == "") target = file
      else if (path ~ /^\//) target = normalize(root path)
      else { dir = file; sub(/\/[^\/]*$/, "", dir); target = normalize(dir "/" path) }
      if (!(target in exists) && ((target "/index.html") in exists)) target = target "/index.html"

      if (!(target in exists)) { fail(file, "broken link " url); continue }
      if (frag != "" && target ~ /\.html$/ && !((target, frag) in ids))
        fail(file, "missing anchor " url)
    }
    if (failures) { print failures " problem(s) in " root; exit 1 }
    print "every internal link resolves, nothing loads from another host"
  }
' "${files}" "${pages}"
