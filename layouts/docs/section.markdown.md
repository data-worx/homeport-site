{{- /* A documentation section as Markdown, served next to its HTML. It
       carries what the HTML shows: the start of the documentation lists
       the reader sections, a section without text lists its documents. */ -}}
# {{ .Title }}

URL: {{ .Permalink }}
{{- if eq .Path "/docs" }}
{{- $tag := .Params.homeportVersion }}

{{ T "docsVersion" (dict "Version" $tag) }} [{{ T "docsRelease" }}]({{ site.Params.repo }}/releases/tag/{{ $tag }})
{{- range .Sections }}

## [{{ .Title }}]({{ .Permalink }})
{{- with .Description }}

{{ strings.FirstUpper . }}.
{{- end }}
{{ range .Pages }}
- [{{ .LinkTitle }}]({{ .Permalink }})
{{- end }}
{{- end }}
{{- else }}
{{- with .Description }}

{{ strings.FirstUpper . }}.
{{- end }}
{{- with .RawContent }}

{{ partial "docs-markdown.html" $ | strings.TrimSpace }}
{{- else }}
{{ range .Pages }}
- [{{ .LinkTitle }}]({{ .Permalink }})
{{- end }}
{{- end }}
{{- end }}
