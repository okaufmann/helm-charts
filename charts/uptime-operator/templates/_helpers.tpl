{{/*
Expand the name of the chart.
*/}}
{{- define "uptime-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "uptime-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "uptime-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "uptime-operator.labels" -}}
helm.sh/chart: {{ include "uptime-operator.chart" . }}
{{ include "uptime-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "uptime-operator.selectorLabels" -}}
app.kubernetes.io/name: uptime-operator
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "uptime-operator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "uptime-operator.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "uptime-operator.secretName" -}}
{{- if .Values.secret.create }}
{{- include "uptime-operator.fullname" . }}
{{- else if .Values.existingSecret }}
{{- .Values.existingSecret }}
{{- else }}
{{- fail "Set existingSecret or secret.create=true to provide Kuma credentials." }}
{{- end }}
{{- end }}

{{- define "uptime-operator.configMapName" -}}
{{- printf "%s-config" (include "uptime-operator.fullname" .) }}
{{- end }}

{{- define "uptime-operator.staticMonitorsConfigMapName" -}}
{{- printf "%s-static-monitors" (include "uptime-operator.fullname" .) }}
{{- end }}
