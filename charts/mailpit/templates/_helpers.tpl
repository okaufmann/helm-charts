{{/*
Expand the name of the chart.
*/}}
{{- define "mailpit.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mailpit.fullname" -}}
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

{{- define "mailpit.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mailpit.labels" -}}
helm.sh/chart: {{ include "mailpit.chart" . }}
{{ include "mailpit.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "mailpit.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mailpit.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mailpit.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mailpit.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "mailpit.envFrom" -}}
- configMapRef:
    name: {{ include "mailpit.fullname" . }}-config
{{- range .Values.existingEnvSecrets }}
- secretRef:
    name: {{ . | quote }}
{{- end }}
{{- end }}

{{- define "mailpit.pvcName" -}}
{{- if .Values.persistence.existingClaim }}
{{- .Values.persistence.existingClaim }}
{{- else if .Values.persistence.name }}
{{- .Values.persistence.name }}
{{- else }}
{{- printf "%s-data" (include "mailpit.fullname" .) }}
{{- end }}
{{- end }}

{{- define "mailpit.spamassassinName" -}}
{{- printf "%s-spamassassin" (include "mailpit.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mailpit.spamassassinAddr" -}}
{{- printf "%s:%v" (include "mailpit.spamassassinName" .) .Values.spamassassin.service.port }}
{{- end }}
