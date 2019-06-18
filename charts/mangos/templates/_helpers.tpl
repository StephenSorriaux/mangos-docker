{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create repository name base
*/}}
{{- define "repository.base" }}
{{- if eq (.Values.wowVersion | int) 0 -}}
ssorriaux/mangoszero
{{- else if eq (.Values.wowVersion | int) 1 -}}
ssorriaux/mangosone
{{- else if eq (.Values.wowVersion | int) 2 -}}
ssorriaux/mangostwo
{{- else if eq (.Values.wowVersion | int) 3 -}}
ssorriaux/mangosthree
{{- else if eq (.Values.wowVersion | int) 4 -}}
ssorriaux/mangosfour
{{- else if eq (.Values.wowVersion | int) 5 -}}
ssorriaux/mangosfive
{{- end -}}
{{- end -}}

{{/*
Create repository name for world server
*/}}
{{- define "repository.world" -}}
{{- template "repository.base" . }}-server
{{- end -}}

{{/*
Create repository name for auth server
*/}}
{{- define "repository.realmd" -}}
{{- template "repository.base" . }}-realmd
{{- end -}}

{{/*
Create repository name for mysql
*/}}
{{- define "repository.mysql" -}}
{{- template "repository.base" . }}-database-mysql
{{- end -}}