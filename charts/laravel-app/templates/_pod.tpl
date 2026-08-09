{{/*
Shared pod specification for the Laravel application workloads.

Expected arguments:
  ctx:       root Helm context
  component: app, queue, scheduler, or reverb
  values:    component values
*/}}
{{- define "laravel-app.podSpec" -}}
{{- $root := .ctx -}}
{{- $component := .component -}}
{{- $values := .values -}}
{{- $podSecurityContext := mustMergeOverwrite (deepCopy ($root.Values.podSecurityContext | default dict)) ($values.podSecurityContext | default dict) -}}
{{- $containerSecurityContext := mustMergeOverwrite (deepCopy ($root.Values.containerSecurityContext | default dict)) ($values.containerSecurityContext | default dict) -}}
automountServiceAccountToken: {{ $root.Values.automountServiceAccountToken }}
{{- with $root.Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- if or $root.Values.serviceAccount.create $root.Values.serviceAccount.name }}
serviceAccountName: {{ include "laravel-app.serviceAccountName" $root }}
{{- end }}
securityContext:
  {{- toYaml $podSecurityContext | nindent 2 }}
terminationGracePeriodSeconds: {{ $values.terminationGracePeriodSeconds }}
{{- with $values.priorityClassName }}
priorityClassName: {{ . | quote }}
{{- end }}
volumes:
  - name: runtime-cache
    emptyDir:
      sizeLimit: {{ $values.runtimeCache.sizeLimit | quote }}
  {{- if and $root.Values.statamic.enabled (ne $component "reverb") }}
  - name: data
    emptyDir: {}
  - name: statamic
    persistentVolumeClaim:
      claimName: {{ include "laravel-app.fullname" $root }}-statamic-pvc
  - name: init-script
    configMap:
      defaultMode: 0550
      name: {{ include "laravel-app.fullname" $root }}-init-script
  {{- end }}
  {{- with $values.extraVolumes }}
  {{- toYaml . | nindent 2 }}
  {{- end }}
{{- if or $values.initCommands (and (eq $component "app") $values.migrate.enabled (eq $values.migrate.mode "initContainer")) }}
initContainers:
  {{- with $values.initCommands }}
  - name: init
    image: "{{ $values.image.repository }}:{{ $values.image.tag | default $root.Chart.AppVersion }}"
    imagePullPolicy: {{ $values.image.pullPolicy }}
    securityContext:
      {{- toYaml $containerSecurityContext | nindent 6 }}
    command: ["/bin/sh", "-c"]
    args:
      - {{ printf "%s && true" (join " && " .) | quote }}
    volumeMounts:
      - name: runtime-cache
        mountPath: {{ $root.Values.webRoot }}/bootstrap/cache
      {{- if and $root.Values.statamic.enabled (ne $component "reverb") }}
      - name: statamic
        mountPath: /data/git
      - name: data
        mountPath: /data
      {{- end }}
    envFrom:
      {{- include "laravel-app.envFrom" $root | nindent 6 }}
  {{- end }}
  {{- if and (eq $component "app") $values.migrate.enabled (eq $values.migrate.mode "initContainer") }}
  - name: migrate
    image: "{{ $values.image.repository }}:{{ $values.image.tag | default $root.Chart.AppVersion }}"
    imagePullPolicy: {{ $values.image.pullPolicy }}
    securityContext:
      {{- toYaml $containerSecurityContext | nindent 6 }}
    command: ["/bin/sh", "-c"]
    args:
      - {{ $values.migrate.command | quote }}
    volumeMounts:
      - name: runtime-cache
        mountPath: {{ $root.Values.webRoot }}/bootstrap/cache
      {{- if $root.Values.statamic.enabled }}
      - name: statamic
        mountPath: /data/git
      - name: data
        mountPath: /data
      {{- end }}
    envFrom:
      {{- include "laravel-app.envFrom" $root | nindent 6 }}
  {{- end }}
{{- end }}
containers:
  - name: {{ $component }}
    image: "{{ $values.image.repository }}:{{ $values.image.tag | default $root.Chart.AppVersion }}"
    imagePullPolicy: {{ $values.image.pullPolicy }}
    securityContext:
      {{- toYaml $containerSecurityContext | nindent 6 }}
    {{- if $values.command }}
    command: ["/bin/sh", "-c"]
    args:
      - {{ $values.command | quote }}
    {{- else if and (eq $component "app") $values.octane.enabled }}
    command: ["/bin/sh", "-c"]
    args:
      - {{ printf "php artisan octane:start --server=%s --host=%s --port=%v --max-requests=%v%s" $values.octane.server $values.octane.host $values.octane.port $values.octane.maxRequests (ternary (printf " --workers=%v" $values.octane.workers) "" (not (empty $values.octane.workers))) | quote }}
    {{- end }}
    volumeMounts:
      - name: runtime-cache
        mountPath: {{ $root.Values.webRoot }}/bootstrap/cache
      {{- if and $root.Values.statamic.enabled (ne $component "reverb") }}
      - name: statamic
        mountPath: /data/git
      - name: data
        mountPath: /data
      - name: init-script
        mountPath: /app/init.sh
        subPath: init.sh
        readOnly: true
      {{- end }}
      {{- with $values.extraVolumeMounts }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
    envFrom:
      {{- include "laravel-app.envFrom" $root | nindent 6 }}
    {{- if and $root.Values.statamic.enabled (ne $component "reverb") }}
    env:
      - name: STARTUP_SCRIPT_PATH
        value: /app/init.sh
    {{- end }}
    {{- if or (eq $component "app") (eq $component "reverb") }}
    ports:
      - name: http
        containerPort: {{ if and (eq $component "app") $values.octane.enabled }}{{ $values.octane.port }}{{ else }}{{ $values.service.targetPort }}{{ end }}
        protocol: TCP
    {{- end }}
    {{- with $values.startupProbe }}
    startupProbe:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- with $values.livenessProbe }}
    livenessProbe:
      {{- if and (eq $component "app") $values.octane.enabled }}
      {{- toYaml $values.octane.livenessProbe | nindent 6 }}
      {{- else }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
    {{- with $values.readinessProbe }}
    readinessProbe:
      {{- if and (eq $component "app") $values.octane.enabled }}
      {{- toYaml $values.octane.readinessProbe | nindent 6 }}
      {{- else }}
      {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
    {{- with $values.lifecycle }}
    lifecycle:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    resources:
      {{- toYaml $values.resources | nindent 6 }}
{{- with $values.nodeSelector }}
nodeSelector:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $values.affinity }}
affinity:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $values.topologySpreadConstraints }}
topologySpreadConstraints:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with $values.tolerations }}
tolerations:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
