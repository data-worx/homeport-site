{{- /* A documentation page as Markdown, served next to its HTML. */ -}}
# {{ .Title }}

URL: {{ .Permalink }}

{{ partial "docs-markdown.html" . | strings.TrimSpace }}
