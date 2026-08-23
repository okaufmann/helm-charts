{{/*
Expand the name of the chart.
*/}}
{{- define "node-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "node-app.fullname" -}}
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

{{- define "node-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "node-app.labels" -}}
helm.sh/chart: {{ include "node-app.chart" . }}
{{ include "node-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "node-app.selectorLabels" -}}
app.kubernetes.io/name: node-app
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "node-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "node-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "node-app.envFrom" -}}
- configMapRef:
    name: {{ include "node-app.fullname" . }}-config
{{- range .Values.existingEnvSecrets }}
- secretRef:
    name: {{ . | quote }}
{{- end }}
{{- end }}
