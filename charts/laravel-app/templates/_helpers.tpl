{{/*
Expand the name of the chart.
*/}}
{{- define "laravel-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "laravel-app.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "laravel-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "laravel-app.labels" -}}
helm.sh/chart: {{ include "laravel-app.chart" . }}
{{ include "laravel-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "laravel-app.selectorLabels" -}}
app.kubernetes.io/name: laravel-app
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "laravel-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "laravel-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Statamic SSH Secret name.
*/}}
{{- define "laravel-app.statamicSshSecretName" -}}
{{- default (printf "%s-statamic-ssh" (include "laravel-app.fullname" .)) .Values.statamic.repo.existingSecret }}
{{- end }}

{{/*
Environment sources shared by application workloads.
*/}}
{{- define "laravel-app.envFrom" -}}
- configMapRef:
    name: {{ include "laravel-app.fullname" . }}-config
{{- range .Values.existingEnvSecrets }}
- secretRef:
    name: {{ . | quote }}
{{- end }}
{{- end }}

{{/*
Name of the Secret containing MEILI_MASTER_KEY. An existing Secret takes
precedence; otherwise the chart-managed Secret is release-scoped.
*/}}
{{- define "laravel-app.meilisearchSecretName" -}}
{{- if .Values.meilisearch.enabled -}}
  {{- if .Values.meiliMasterKeyExistingSecret -}}
    {{- .Values.meiliMasterKeyExistingSecret -}}
  {{- else if .Values.meilisearch.auth.existingMasterKeySecret -}}
    {{- .Values.meilisearch.auth.existingMasterKeySecret -}}
  {{- else if .Values.meiliMasterKey -}}
    {{- default (printf "%s-meilisearch-master-key" (include "laravel-app.fullname" .)) .Values.meiliMasterKeySecretName -}}
  {{- else -}}
    {{- $dependencyName := "meilisearch" -}}
    {{- $dependencyFullname := ternary .Release.Name (printf "%s-%s" .Release.Name $dependencyName) (contains $dependencyName .Release.Name) -}}
    {{- printf "%s-master-key" ($dependencyFullname | trunc 63 | trimSuffix "-") -}}
  {{- end -}}
{{- end -}}
{{- end }}

{{/*
MEILISEARCH_KEY environment variable as a list item.
*/}}
{{- define "laravel-app.meilisearchEnvList" -}}
{{- with (include "laravel-app.meilisearchSecretName" .) }}
- name: MEILISEARCH_KEY
  valueFrom:
    secretKeyRef:
      name: {{ . | quote }}
      key: MEILI_MASTER_KEY
{{- end }}
{{- end }}

{{/*
MEILISEARCH_KEY environment block for containers without another env block.
*/}}
{{- define "laravel-app.meilisearchEnv" -}}
{{- with (include "laravel-app.meilisearchSecretName" .) }}
env:
  {{- include "laravel-app.meilisearchEnvList" $ | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Deployment name for a component.
*/}}
{{- define "laravel-app.componentDeploymentName" -}}
{{- if eq .component "app" -}}
{{ include "laravel-app.fullname" .ctx }}-webapp
{{- else -}}
{{ include "laravel-app.fullname" .ctx }}-{{ .component }}
{{- end -}}
{{- end }}
