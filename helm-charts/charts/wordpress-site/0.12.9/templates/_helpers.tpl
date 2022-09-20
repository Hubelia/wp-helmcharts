{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wordpress-site.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wordpress-site.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Return the secret for github app
*/}}
{{- define "wordpress-site.git_app_secret" -}}
{{- $fullName := include "wordpress-site.fullname" . -}}
{{- default $fullName .Values.code.git.github_app_secret | quote -}}
{{- end -}}

{{/*
Return the secret for github app
*/}}
{{- define "wordpress-site.db_encryption_key" -}}
{{- $fullName := include "wordpress-site.fullname" . -}}
{{- default $fullName .Values.code.db.encryption_key | quote -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wordpress-site.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
