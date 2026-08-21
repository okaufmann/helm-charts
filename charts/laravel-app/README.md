# laravel-app

![Version: 2.0.4](https://img.shields.io/badge/Version-2.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for running Laravel or Statamic Apps

**Homepage:** <https://github.com/okaufmann/helm-charts/tree/main/charts/laravel-app>

# Overview

This is a generic Helm Chart for Laravel Applications. It is based on the [serversideup/php](https://serversideup.net/open-source/docker-php/) Docker image.

## Installation

### Add Helm Repository

```
helm repo add olidev https://helm-charts.oli-the.dev
helm repo update
```

### Install to Kubernetes

In order to install laravel-app successfully you can just use this command.

```
helm install -n <NAMESPACE> laravel-app olidev/laravel-app
```

## Security

Version 2 defaults application pods to the Kubernetes restricted Pod Security
Standard: pods run as non-root, use the runtime-default seccomp profile, drop
all Linux capabilities, disable privilege escalation, and do not mount a
Kubernetes API token. The default `serversideup/php` Debian image runs as
`www-data` (UID/GID 33). Override the pod security context when using Alpine or
a custom image with a different user.

Values under `envs` are rendered into a ConfigMap and are not secret. Put
`APP_KEY`, database credentials, and other sensitive values in one or more
pre-created Secrets and list their names under `existingEnvSecrets`.
Valkey authentication is enabled when the dependency is enabled. Prefer a
pre-created `valkey.auth.existingSecret` so the Laravel application can consume
the same password through `existingEnvSecrets`.

`networkPolicy.enabled` applies default-deny ingress and egress to application
pods. Before enabling it, add egress rules for external databases, mail
providers, object storage, and any third-party APIs the application needs.

## Operations

CPU/memory HPAs require matching resource requests on the scaled component.
Configure `resources.requests` before enabling autoscaling.

The default migration mode runs `php artisan migrate --isolated --force` as an
init container. `--isolated` requires a shared cache driver that supports
atomic locks. For multi-replica releases, `app.migrate.mode: hook` instead runs
one Helm pre-install/pre-upgrade Job. Hook mode injects ConfigMap values
directly because pre-install hooks run before normal chart resources exist.

## Development

### Prerequisites

- [Docker](https://www.docker.com/)
- [Helm](https://helm.sh/)
- [Kubernetes](https://kubernetes.io/)
- [Minikube](https://minikube.sigs.k8s.io/docs/)

### Setup

Ensure dependencies are up to date:
  helm dependency update

Generate manifests into output directory:
  helm template --output-dir output . -f values.yaml --debug > output.txt

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| okaufmann |  | <https://github.com/okaufmann> |

## Requirements

Kubernetes: `>=1.25.0-0`

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | valkey | 6.2.x |

## Source Code

* <https://github.com/okaufmann/helm-charts>
* <https://github.com/serversideup/docker-php>

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Change** | **Chart Version** | **Description** | **Commits/PRs** |
| :----------- | :---------------- | :--------------------- | :-------------- |
| Secure workload defaults | 2.0.0 | `securityContext` was replaced by global and per-component `podSecurityContext` / `containerSecurityContext`. API token automounting now defaults off. | |
| Secret environment sources | 2.0.0 | Replace `existingEnvSecret: name` with `existingEnvSecrets: [name]`. | |
| Registry credentials | 2.0.0 | `imagePullSecrets` now defaults to an empty list instead of the cluster-specific `regcred`. | |
| Non-root HTTP port | 2.0.0 | `app.service.targetPort` now defaults to `8080`, matching serversideup/php v3. | |
| Health endpoint | 2.0.0 | App probes now use Laravel's `/up` endpoint and include a startup probe. Override probe values for older applications. | |
| Scheduler safety | 2.0.0 | Scheduler replica/autoscaling values were removed; it always runs one replica with a `Recreate` strategy. | |
| Statamic Git image | 2.0.0 | Untagged `bitnamilegacy/git` was replaced by pinned, configurable `statamic.git.image` values. | |
| Statamic Git branch | 2.0.4 | `statamic.repo.branch` selects the clone/pull ref. Dirty PVC trees skip pull so in-cluster edits survive upgrades. | |
| Valkey authentication | 2.0.0 | Authentication now defaults on and the insecure `yourpassword` placeholder was removed. | |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| app.affinity | object | `{}` |  |
| app.autoscaling.behavior | object | `{}` |  |
| app.autoscaling.enabled | bool | `false` |  |
| app.autoscaling.maxReplicas | int | `100` |  |
| app.autoscaling.minReplicas | int | `1` |  |
| app.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| app.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| app.command | string | `nil` |  |
| app.containerSecurityContext | object | `{}` |  |
| app.enabled | bool | `true` |  |
| app.extraVolumeMounts | list | `[]` |  |
| app.extraVolumes | list | `[]` |  |
| app.image.pullPolicy | string | `"Always"` |  |
| app.image.repository | string | `"serversideup/php"` |  |
| app.image.tag | string | `"8.5-fpm-nginx"` |  |
| app.ingress.annotations | object | `{}` |  |
| app.ingress.enabled | bool | `false` |  |
| app.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| app.ingress.hosts[0].paths[0] | string | `"/"` |  |
| app.ingress.ingressClassName | string | `""` |  |
| app.ingress.tls[0].hosts[0] | string | `"app.example.com"` |  |
| app.ingress.tls[0].secretName | string | `"app.example.com"` |  |
| app.initCommands[0] | string | `"php artisan optimize"` |  |
| app.initCommands[1] | string | `"php artisan view:cache"` |  |
| app.lifecycle | object | `{}` |  |
| app.livenessProbe.failureThreshold | int | `5` |  |
| app.livenessProbe.httpGet.path | string | `"/up"` |  |
| app.livenessProbe.httpGet.port | string | `"http"` |  |
| app.livenessProbe.initialDelaySeconds | int | `60` |  |
| app.livenessProbe.periodSeconds | int | `15` |  |
| app.livenessProbe.timeoutSeconds | int | `5` |  |
| app.migrate.backoffLimit | int | `3` |  |
| app.migrate.command | string | `"php artisan migrate --isolated --force"` |  |
| app.migrate.enabled | bool | `true` |  |
| app.migrate.mode | string | `"initContainer"` |  |
| app.migrate.resources | object | `{}` |  |
| app.migrate.ttlSecondsAfterFinished | int | `300` |  |
| app.nodeSelector | object | `{}` |  |
| app.octane.enabled | bool | `false` |  |
| app.octane.host | string | `"0.0.0.0"` |  |
| app.octane.livenessProbe.failureThreshold | int | `5` |  |
| app.octane.livenessProbe.httpGet.path | string | `"/up"` |  |
| app.octane.livenessProbe.httpGet.port | string | `"http"` |  |
| app.octane.livenessProbe.initialDelaySeconds | int | `15` |  |
| app.octane.livenessProbe.periodSeconds | int | `15` |  |
| app.octane.livenessProbe.timeoutSeconds | int | `5` |  |
| app.octane.logLevel | string | `"info"` |  |
| app.octane.maxRequests | int | `500` |  |
| app.octane.port | int | `8080` |  |
| app.octane.readinessProbe.httpGet.path | string | `"/up"` |  |
| app.octane.readinessProbe.httpGet.port | string | `"http"` |  |
| app.octane.readinessProbe.initialDelaySeconds | int | `5` |  |
| app.octane.readinessProbe.periodSeconds | int | `10` |  |
| app.octane.readinessProbe.timeoutSeconds | int | `5` |  |
| app.octane.server | string | `"frankenphp"` |  |
| app.octane.workers | string | `""` |  |
| app.podAnnotations | object | `{}` |  |
| app.podDisruptionBudget.enabled | bool | `false` |  |
| app.podDisruptionBudget.maxUnavailable | string | `nil` |  |
| app.podDisruptionBudget.minAvailable | int | `1` |  |
| app.podSecurityContext | object | `{}` |  |
| app.priorityClassName | string | `""` |  |
| app.readinessProbe.httpGet.path | string | `"/up"` |  |
| app.readinessProbe.httpGet.port | string | `"http"` |  |
| app.readinessProbe.initialDelaySeconds | int | `10` |  |
| app.readinessProbe.periodSeconds | int | `10` |  |
| app.readinessProbe.timeoutSeconds | int | `5` |  |
| app.replicaCount | int | `1` |  |
| app.resources | object | `{}` |  |
| app.revisionHistoryLimit | int | `10` |  |
| app.runtimeCache.sizeLimit | string | `"64Mi"` |  |
| app.service.annotations | object | `{}` |  |
| app.service.externalTrafficPolicy | string | `"Cluster"` |  |
| app.service.labels | object | `{}` |  |
| app.service.loadBalancerIP | string | `""` |  |
| app.service.loadBalancerSourceRanges | list | `[]` |  |
| app.service.nodePort | string | `nil` |  |
| app.service.port | int | `80` |  |
| app.service.targetPort | int | `8080` |  |
| app.service.type | string | `"ClusterIP"` |  |
| app.serviceMonitor.enabled | bool | `false` |  |
| app.startupProbe.failureThreshold | int | `30` |  |
| app.startupProbe.httpGet.path | string | `"/up"` |  |
| app.startupProbe.httpGet.port | string | `"http"` |  |
| app.startupProbe.periodSeconds | int | `5` |  |
| app.startupProbe.timeoutSeconds | int | `5` |  |
| app.strategy.rollingUpdate.maxSurge | int | `1` |  |
| app.strategy.rollingUpdate.maxUnavailable | int | `0` |  |
| app.strategy.type | string | `"RollingUpdate"` |  |
| app.terminationGracePeriodSeconds | int | `30` |  |
| app.tolerations | list | `[]` |  |
| app.topologySpreadConstraints | list | `[]` |  |
| automountServiceAccountToken | bool | `false` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| envs | object | `{}` |  |
| existingEnvSecrets | list | `[]` |  |
| global | object | `{}` |  |
| imagePullSecrets | list | `[]` |  |
| networkPolicy.egress.additionalRules | list | `[]` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.ingress.namespaceSelector.matchLabels."kubernetes.io/metadata.name" | string | `"ingress-nginx"` |  |
| networkPolicy.ingress.podSelector.matchLabels."app.kubernetes.io/name" | string | `"ingress-nginx"` |  |
| podSecurityContext.fsGroup | int | `33` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| podSecurityContext.runAsGroup | int | `33` |  |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.runAsUser | int | `33` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| queue.affinity | object | `{}` |  |
| queue.autoscaling.behavior | object | `{}` |  |
| queue.autoscaling.enabled | bool | `false` |  |
| queue.autoscaling.maxReplicas | int | `100` |  |
| queue.autoscaling.minReplicas | int | `1` |  |
| queue.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| queue.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| queue.command | string | `"php artisan horizon"` |  |
| queue.containerSecurityContext | object | `{}` |  |
| queue.enabled | bool | `false` |  |
| queue.extraVolumeMounts | list | `[]` |  |
| queue.extraVolumes | list | `[]` |  |
| queue.image.pullPolicy | string | `"Always"` |  |
| queue.image.repository | string | `"serversideup/php"` |  |
| queue.image.tag | string | `"8.5-cli"` |  |
| queue.initCommands[0] | string | `"php artisan optimize"` |  |
| queue.initCommands[1] | string | `"php artisan view:cache"` |  |
| queue.lifecycle | object | `{}` |  |
| queue.nodeSelector | object | `{}` |  |
| queue.podAnnotations | object | `{}` |  |
| queue.podDisruptionBudget.enabled | bool | `false` |  |
| queue.podDisruptionBudget.maxUnavailable | string | `nil` |  |
| queue.podDisruptionBudget.minAvailable | int | `1` |  |
| queue.podSecurityContext | object | `{}` |  |
| queue.priorityClassName | string | `""` |  |
| queue.replicaCount | int | `1` |  |
| queue.resources | object | `{}` |  |
| queue.revisionHistoryLimit | int | `10` |  |
| queue.runtimeCache.sizeLimit | string | `"64Mi"` |  |
| queue.strategy.rollingUpdate.maxSurge | int | `1` |  |
| queue.strategy.rollingUpdate.maxUnavailable | string | `"50%"` |  |
| queue.strategy.type | string | `"RollingUpdate"` |  |
| queue.terminationGracePeriodSeconds | int | `300` |  |
| queue.tolerations | list | `[]` |  |
| queue.topologySpreadConstraints | list | `[]` |  |
| reverb.affinity | object | `{}` |  |
| reverb.autoscaling.behavior | object | `{}` |  |
| reverb.autoscaling.enabled | bool | `false` |  |
| reverb.autoscaling.maxReplicas | int | `20` |  |
| reverb.autoscaling.minReplicas | int | `1` |  |
| reverb.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| reverb.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| reverb.command | string | `"php artisan reverb:start --host=0.0.0.0 --port=8080"` |  |
| reverb.containerSecurityContext | object | `{}` |  |
| reverb.enabled | bool | `false` |  |
| reverb.extraVolumeMounts | list | `[]` |  |
| reverb.extraVolumes | list | `[]` |  |
| reverb.image.pullPolicy | string | `"Always"` |  |
| reverb.image.repository | string | `"serversideup/php"` |  |
| reverb.image.tag | string | `"8.5-cli"` |  |
| reverb.ingress.annotations | object | `{}` |  |
| reverb.ingress.enabled | bool | `false` |  |
| reverb.ingress.hosts[0].host | string | `"reverb.example.com"` |  |
| reverb.ingress.hosts[0].paths[0] | string | `"/"` |  |
| reverb.ingress.ingressClassName | string | `""` |  |
| reverb.ingress.tls | list | `[]` |  |
| reverb.lifecycle | object | `{}` |  |
| reverb.livenessProbe.initialDelaySeconds | int | `15` |  |
| reverb.livenessProbe.periodSeconds | int | `20` |  |
| reverb.livenessProbe.tcpSocket.port | string | `"http"` |  |
| reverb.livenessProbe.timeoutSeconds | int | `5` |  |
| reverb.nodeSelector | object | `{}` |  |
| reverb.podAnnotations | object | `{}` |  |
| reverb.podDisruptionBudget.enabled | bool | `false` |  |
| reverb.podDisruptionBudget.maxUnavailable | string | `nil` |  |
| reverb.podDisruptionBudget.minAvailable | int | `1` |  |
| reverb.podSecurityContext | object | `{}` |  |
| reverb.priorityClassName | string | `""` |  |
| reverb.readinessProbe.initialDelaySeconds | int | `5` |  |
| reverb.readinessProbe.periodSeconds | int | `10` |  |
| reverb.readinessProbe.tcpSocket.port | string | `"http"` |  |
| reverb.readinessProbe.timeoutSeconds | int | `5` |  |
| reverb.replicaCount | int | `1` |  |
| reverb.resources | object | `{}` |  |
| reverb.revisionHistoryLimit | int | `10` |  |
| reverb.runtimeCache.sizeLimit | string | `"64Mi"` |  |
| reverb.service.annotations | object | `{}` |  |
| reverb.service.externalTrafficPolicy | string | `"Cluster"` |  |
| reverb.service.labels | object | `{}` |  |
| reverb.service.loadBalancerIP | string | `""` |  |
| reverb.service.loadBalancerSourceRanges | list | `[]` |  |
| reverb.service.nodePort | string | `nil` |  |
| reverb.service.port | int | `8080` |  |
| reverb.service.targetPort | int | `8080` |  |
| reverb.service.type | string | `"ClusterIP"` |  |
| reverb.startupProbe.failureThreshold | int | `30` |  |
| reverb.startupProbe.periodSeconds | int | `2` |  |
| reverb.startupProbe.tcpSocket.port | string | `"http"` |  |
| reverb.strategy.rollingUpdate.maxSurge | int | `1` |  |
| reverb.strategy.rollingUpdate.maxUnavailable | int | `0` |  |
| reverb.strategy.type | string | `"RollingUpdate"` |  |
| reverb.terminationGracePeriodSeconds | int | `30` |  |
| reverb.tolerations | list | `[]` |  |
| reverb.topologySpreadConstraints | list | `[]` |  |
| scheduler.affinity | object | `{}` |  |
| scheduler.command | string | `"php artisan schedule:work"` |  |
| scheduler.containerSecurityContext | object | `{}` |  |
| scheduler.enabled | bool | `false` |  |
| scheduler.extraVolumeMounts | list | `[]` |  |
| scheduler.extraVolumes | list | `[]` |  |
| scheduler.image.pullPolicy | string | `"Always"` |  |
| scheduler.image.repository | string | `"serversideup/php"` |  |
| scheduler.image.tag | string | `"8.5-cli"` |  |
| scheduler.initCommands[0] | string | `"php artisan optimize"` |  |
| scheduler.initCommands[1] | string | `"php artisan view:cache"` |  |
| scheduler.lifecycle | object | `{}` |  |
| scheduler.nodeSelector | object | `{}` |  |
| scheduler.podAnnotations | object | `{}` |  |
| scheduler.podSecurityContext | object | `{}` |  |
| scheduler.priorityClassName | string | `""` |  |
| scheduler.resources | object | `{}` |  |
| scheduler.revisionHistoryLimit | int | `10` |  |
| scheduler.runtimeCache.sizeLimit | string | `"64Mi"` |  |
| scheduler.terminationGracePeriodSeconds | int | `30` |  |
| scheduler.tolerations | list | `[]` |  |
| scheduler.topologySpreadConstraints | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| statamic.enabled | bool | `false` |  |
| statamic.git.affinity | object | `{}` |  |
| statamic.git.backoffLimit | int | `3` |  |
| statamic.git.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| statamic.git.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| statamic.git.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| statamic.git.email | string | `"statamic@example.com"` |  |
| statamic.git.image.pullPolicy | string | `"IfNotPresent"` |  |
| statamic.git.image.repository | string | `"alpine/git"` |  |
| statamic.git.image.tag | string | `"2.54.0"` |  |
| statamic.git.message | string | `"Update from production [ci skip]"` |  |
| statamic.git.nodeSelector | object | `{}` |  |
| statamic.git.podSecurityContext.fsGroup | int | `33` |  |
| statamic.git.podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` |  |
| statamic.git.podSecurityContext.runAsGroup | int | `33` |  |
| statamic.git.podSecurityContext.runAsNonRoot | bool | `true` |  |
| statamic.git.podSecurityContext.runAsUser | int | `33` |  |
| statamic.git.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| statamic.git.push | bool | `true` |  |
| statamic.git.resources | object | `{}` |  |
| statamic.git.tolerations | list | `[]` |  |
| statamic.git.ttlSecondsAfterFinished | int | `300` |  |
| statamic.git.user | string | `"statamic"` |  |
| statamic.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| statamic.persistence.size | string | `"10Gi"` |  |
| statamic.persistence.storageClass | string | `""` |  |
| statamic.repo.branch | string | `""` |  |
| statamic.repo.existingSecret | string | `""` |  |
| statamic.repo.knownHosts | string | `""` |  |
| statamic.repo.sshPrivateKey | string | `""` |  |
| statamic.repo.sshUrl | string | `"git@github.com:org/repository.git"` |  |
| statamic.schedule | string | `"*/10 * * * *"` |  |
| valkey.architecture | string | `"standalone"` |  |
| valkey.auth.enabled | bool | `true` |  |
| valkey.auth.password | string | `""` |  |
| valkey.enabled | bool | `false` |  |
| valkey.primary.disableCommands[0] | string | `"FLUSHALL"` |  |
| valkey.primary.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| valkey.primary.persistence.enabled | bool | `true` |  |
| valkey.primary.persistence.size | string | `"8Gi"` |  |
| valkey.primary.persistence.storageClass | string | `""` |  |
| webRoot | string | `"/var/www/html"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
