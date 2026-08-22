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
Deployment name for a component.
*/}}
{{- define "laravel-app.componentDeploymentName" -}}
{{- if eq .component "app" -}}
{{ include "laravel-app.fullname" .ctx }}-webapp
{{- else -}}
{{ include "laravel-app.fullname" .ctx }}-{{ .component }}
{{- end -}}
{{- end }}

{{/*
UID/GID the Statamic git job runs as. alpine/git has no passwd row for
www-data (33); the job mounts a generated passwd so OpenSSH can run.
*/}}
{{- define "laravel-app.statamicGitUid" -}}
{{- dig "runAsUser" 33 (.Values.statamic.git.podSecurityContext | default dict) -}}
{{- end }}

{{- define "laravel-app.statamicGitGid" -}}
{{- dig "runAsGroup" 33 (.Values.statamic.git.podSecurityContext | default dict) -}}
{{- end }}

{{/*
ConfigMap file mounts are recursively remounted read-only. runc rejects that
on a file such as /etc/passwd ("not a directory"). Copy the generated NSS
files into an emptyDir, then bind-mount those regular files.
*/}}
{{- define "laravel-app.statamicGitNssVolume" -}}
- name: nss
  emptyDir: {}
{{- end }}

{{- define "laravel-app.statamicGitNssInit" -}}
- name: nss
  image: "{{ .Values.statamic.git.image.repository }}:{{ .Values.statamic.git.image.tag }}"
  imagePullPolicy: {{ .Values.statamic.git.image.pullPolicy }}
  securityContext:
    {{- toYaml .Values.statamic.git.containerSecurityContext | nindent 4 }}
  command:
  - /bin/sh
  - -c
  - cp /scripts/passwd /nss/passwd && cp /scripts/group /nss/group
  volumeMounts:
  - name: scripts
    mountPath: /scripts
    readOnly: true
  - name: nss
    mountPath: /nss
{{- end }}

{{- define "laravel-app.statamicGitNssMounts" -}}
- name: nss
  mountPath: /etc/passwd
  subPath: passwd
- name: nss
  mountPath: /etc/group
  subPath: group
{{- end }}
