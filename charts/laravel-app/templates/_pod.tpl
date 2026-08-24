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
{{- $statamic := and $root.Values.statamic.enabled (ne $component "reverb") -}}
{{- $octane := and (eq $component "app") $values.octane.enabled -}}
{{- $octaneCommand := "" -}}
{{- if $octane -}}
{{- $octaneWorkers := ternary (printf " --workers=%v" $values.octane.workers) "" (not (empty $values.octane.workers)) -}}
{{- $octaneCommand = printf "php artisan octane:start --server=%s --host=%s --port=%v --max-requests=%v --log-level=%s%s" $values.octane.server $values.octane.host $values.octane.port $values.octane.maxRequests (default "info" $values.octane.logLevel) $octaneWorkers -}}
{{- end -}}
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
  {{- if $statamic }}
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
      {{- if $statamic }}
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
    {{- if $statamic }}
    {{/*
      Always start through the linker. Kubernetes drops the image CMD when
      command is set without args, so a missing command here makes init.sh
      exit 0 after linking and the web container crash-loops.
    */}}
    command: ["/app/init.sh"]
    {{- if $values.command }}
    args: ["/bin/sh", "-c", {{ $values.command | quote }}]
    {{- else if $octane }}
    args: ["/bin/sh", "-c", {{ $octaneCommand | quote }}]
    {{- else if eq $component "app" }}
    args: ["/bin/sh", "-c", {{ $root.Values.statamic.webCommand | quote }}]
    {{- end }}
    {{- else if $values.command }}
    command: ["/bin/sh", "-c"]
    args:
      - {{ $values.command | quote }}
    {{- else if $octane }}
    command: ["/bin/sh", "-c"]
    args:
      - {{ $octaneCommand | quote }}
    {{- end }}
    volumeMounts:
      - name: runtime-cache
        mountPath: {{ $root.Values.webRoot }}/bootstrap/cache
      {{- if $statamic }}
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
