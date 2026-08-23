{{/*
Expand the name of the chart.
*/}}
{{- define "paperless-ngx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "paperless-ngx.fullname" -}}
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

{{- define "paperless-ngx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "paperless-ngx.labels" -}}
helm.sh/chart: {{ include "paperless-ngx.chart" . }}
{{ include "paperless-ngx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "paperless-ngx.selectorLabels" -}}
app.kubernetes.io/name: paperless-ngx
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "paperless-ngx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "paperless-ngx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "paperless-ngx.envFrom" -}}
- configMapRef:
    name: {{ include "paperless-ngx.fullname" . }}-config
{{- range .Values.existingEnvSecrets }}
- secretRef:
    name: {{ . | quote }}
{{- end }}
{{- end }}

{{- define "paperless-ngx.pvcName" -}}
{{- if .Values.persistence.existingClaim }}
{{- .Values.persistence.existingClaim }}
{{- else if .Values.persistence.name }}
{{- .Values.persistence.name }}
{{- else }}
{{- printf "%s-data" (include "paperless-ngx.fullname" .) }}
{{- end }}
{{- end }}

{{- define "paperless-ngx.probeHost" -}}
{{- if .Values.app.probeHost }}
{{- .Values.app.probeHost }}
{{- else if and .Values.app.ingress.enabled .Values.app.ingress.hosts }}
{{- (index .Values.app.ingress.hosts 0).host }}
{{- end }}
{{- end }}

{{- define "paperless-ngx.probe" -}}
{{- $probe := index . 0 }}
{{- $host := index . 1 }}
{{- $probeCopy := deepCopy $probe }}
{{- if and $host $probeCopy.httpGet }}
{{- $headers := default list $probeCopy.httpGet.httpHeaders }}
{{- $_ := set $probeCopy.httpGet "httpHeaders" (append $headers (dict "name" "Host" "value" $host)) }}
{{- end }}
{{- toYaml $probeCopy }}
{{- end }}
