# laravel-app

![Version: 1.12.0](https://img.shields.io/badge/Version-1.12.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for running Laravel or Statamic Apps

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

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://meilisearch.github.io/meilisearch-kubernetes | meilisearch | 0.2.x |
| oci://registry-1.docker.io/bitnamicharts | redis | 18.19.x |

# Major Changes

Major Changes to functions are documented with the version affected. **Before upgrading the dependency version, check this section out!**

| **Change** | **Chart Version** | **Description** | **Commits/PRs** |
| :----------- | :---------------- | :--------------------- | :-------------- |
|||||

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| app.affinity | object | `{}` |  |
| app.autoscaling.enabled | bool | `false` |  |
| app.autoscaling.maxReplicas | int | `100` |  |
| app.autoscaling.minReplicas | int | `1` |  |
| app.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| app.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| app.command | string | `nil` |  |
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
| app.livenessProbe.failureThreshold | int | `5` |  |
| app.livenessProbe.httpGet.path | string | `"/health"` |  |
| app.livenessProbe.httpGet.port | int | `80` |  |
| app.livenessProbe.initialDelaySeconds | int | `60` |  |
| app.livenessProbe.periodSeconds | int | `15` |  |
| app.livenessProbe.timeoutSeconds | int | `30` |  |
| app.migrate.command | string | `"php artisan migrate --isolated --force"` |  |
| app.migrate.enabled | bool | `true` |  |
| app.nodeSelector | object | `{}` |  |
| app.octane.enabled | bool | `false` |  |
| app.octane.host | string | `"0.0.0.0"` |  |
| app.octane.livenessProbe.failureThreshold | int | `5` |  |
| app.octane.livenessProbe.httpGet.path | string | `"/up"` |  |
| app.octane.livenessProbe.httpGet.port | string | `"http"` |  |
| app.octane.livenessProbe.initialDelaySeconds | int | `15` |  |
| app.octane.livenessProbe.periodSeconds | int | `15` |  |
| app.octane.livenessProbe.timeoutSeconds | int | `5` |  |
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
| app.podSecurityContext | object | `{}` |  |
| app.readinessProbe.httpGet.path | string | `"/health"` |  |
| app.readinessProbe.httpGet.port | int | `80` |  |
| app.readinessProbe.initialDelaySeconds | int | `10` |  |
| app.readinessProbe.periodSeconds | int | `10` |  |
| app.readinessProbe.timeoutSeconds | int | `10` |  |
| app.replicaCount | int | `1` |  |
| app.resources | object | `{}` |  |
| app.service.annotations | object | `{}` |  |
| app.service.externalTrafficPolicy | string | `"Cluster"` |  |
| app.service.labels | object | `{}` |  |
| app.service.loadBalancerIP | string | `""` |  |
| app.service.loadBalancerSourceRanges | list | `[]` |  |
| app.service.nodePort | string | `""` |  |
| app.service.port | int | `80` |  |
| app.service.targetPort | int | `80` |  |
| app.service.type | string | `"ClusterIP"` |  |
| app.serviceMonitor.enabled | bool | `false` |  |
| app.strategy.rollingUpdate.maxSurge | int | `1` |  |
| app.strategy.rollingUpdate.maxUnavailable | int | `0` |  |
| app.strategy.type | string | `"RollingUpdate"` |  |
| app.tolerations | list | `[]` |  |
| existingEnvSecret | string | `""` |  |
| global | object | `{}` |  |
| imagePullSecrets[0].name | string | `"regcred"` |  |
| meiliMasterKey | string | `""` |  |
| meiliMasterKeySecretName | string | `"meilisearch-master-key"` |  |
| meilisearch.auth.existingMasterKeySecret | string | `"meilisearch-master-key"` | Use an existing Kubernetes secret for the MEILI_MASTER_KEY |
| meilisearch.enabled | bool | `false` |  |
| meilisearch.environment.MEILI_ENV | string | `"production"` | Sets the environment. Either **production** or **development** |
| meilisearch.environment.MEILI_NO_ANALYTICS | bool | `true` | Deactivates analytics |
| meilisearch.fullnameOverride | string | `"laravel-meilisearch"` |  |
| meilisearch.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| meilisearch.persistence.enabled | bool | `true` |  |
| meilisearch.persistence.size | string | `"10Gi"` |  |
| meilisearch.persistence.storageClass | string | `""` |  |
| metrics.enabled | bool | `true` |  |
| queue.affinity | object | `{}` |  |
| queue.autoscaling.enabled | bool | `false` |  |
| queue.autoscaling.maxReplicas | int | `100` |  |
| queue.autoscaling.minReplicas | int | `1` |  |
| queue.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| queue.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| queue.command | string | `"php artisan horizon"` |  |
| queue.enabled | bool | `false` |  |
| queue.extraVolumeMounts | list | `[]` |  |
| queue.extraVolumes | list | `[]` |  |
| queue.image.pullPolicy | string | `"Always"` |  |
| queue.image.repository | string | `"serversideup/php"` |  |
| queue.image.tag | string | `"8.5-cli"` |  |
| queue.initCommands[0] | string | `"php artisan optimize"` |  |
| queue.initCommands[1] | string | `"php artisan view:cache"` |  |
| queue.nodeSelector | object | `{}` |  |
| queue.podAnnotations | object | `{}` |  |
| queue.podSecurityContext | object | `{}` |  |
| queue.replicaCount | int | `1` |  |
| queue.resources | object | `{}` |  |
| queue.strategy.rollingUpdate.maxSurge | int | `1` |  |
| queue.strategy.rollingUpdate.maxUnavailable | string | `"50%"` |  |
| queue.strategy.type | string | `"RollingUpdate"` |  |
| queue.tolerations | list | `[]` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.auth.enabled | bool | `false` |  |
| redis.auth.password | string | `"yourpassword"` |  |
| redis.enabled | bool | `false` |  |
| redis.fullnameOverride | string | `"laravel-redis"` |  |
| redis.image.repository | string | `"bitnamilegacy/redis"` |  |
| redis.master.disableCommands[0] | string | `"FLUSHALL"` |  |
| redis.master.persistance.accessModes[0] | string | `"ReadWriteOnce"` |  |
| redis.master.persistance.enabled | bool | `true` |  |
| redis.master.persistance.size | string | `"8Gi"` |  |
| redis.master.persistance.storageClass | string | `""` |  |
| reverb.affinity | object | `{}` |  |
| reverb.command | string | `"php artisan reverb:start --host=0.0.0.0 --port=8080"` |  |
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
| reverb.livenessProbe.initialDelaySeconds | int | `15` |  |
| reverb.livenessProbe.periodSeconds | int | `20` |  |
| reverb.livenessProbe.tcpSocket.port | string | `"http"` |  |
| reverb.livenessProbe.timeoutSeconds | int | `5` |  |
| reverb.nodeSelector | object | `{}` |  |
| reverb.podAnnotations | object | `{}` |  |
| reverb.podSecurityContext | object | `{}` |  |
| reverb.readinessProbe.initialDelaySeconds | int | `5` |  |
| reverb.readinessProbe.periodSeconds | int | `10` |  |
| reverb.readinessProbe.tcpSocket.port | string | `"http"` |  |
| reverb.readinessProbe.timeoutSeconds | int | `5` |  |
| reverb.replicaCount | int | `1` |  |
| reverb.resources | object | `{}` |  |
| reverb.service.annotations | object | `{}` |  |
| reverb.service.labels | object | `{}` |  |
| reverb.service.port | int | `8080` |  |
| reverb.service.targetPort | int | `8080` |  |
| reverb.service.type | string | `"ClusterIP"` |  |
| reverb.strategy.rollingUpdate.maxSurge | int | `1` |  |
| reverb.strategy.rollingUpdate.maxUnavailable | int | `0` |  |
| reverb.strategy.type | string | `"RollingUpdate"` |  |
| reverb.tolerations | list | `[]` |  |
| scheduler.affinity | object | `{}` |  |
| scheduler.autoscaling.enabled | bool | `false` |  |
| scheduler.autoscaling.maxReplicas | int | `100` |  |
| scheduler.autoscaling.minReplicas | int | `1` |  |
| scheduler.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| scheduler.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| scheduler.command | string | `"php artisan schedule:work"` |  |
| scheduler.enabled | bool | `false` |  |
| scheduler.extraVolumeMounts | list | `[]` |  |
| scheduler.extraVolumes | list | `[]` |  |
| scheduler.image.pullPolicy | string | `"Always"` |  |
| scheduler.image.repository | string | `"serversideup/php"` |  |
| scheduler.image.tag | string | `"8.5-cli"` |  |
| scheduler.initCommands[0] | string | `"php artisan optimize"` |  |
| scheduler.initCommands[1] | string | `"php artisan view:cache"` |  |
| scheduler.nodeSelector | object | `{}` |  |
| scheduler.podAnnotations | object | `{}` |  |
| scheduler.podSecurityContext | object | `{}` |  |
| scheduler.replicaCount | int | `1` |  |
| scheduler.resources | object | `{}` |  |
| scheduler.strategy.rollingUpdate.maxSurge | int | `1` |  |
| scheduler.strategy.rollingUpdate.maxUnavailable | int | `0` |  |
| scheduler.strategy.type | string | `"RollingUpdate"` |  |
| scheduler.tolerations | list | `[]` |  |
| securityContext | object | `{}` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| statamic.enabled | bool | `false` |  |
| statamic.git.email | string | `"statamic@example.com"` |  |
| statamic.git.message | string | `"Update from production [ci skip]"` |  |
| statamic.git.push | bool | `true` |  |
| statamic.git.user | string | `"statamic"` |  |
| statamic.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| statamic.persistence.size | string | `"10Gi"` |  |
| statamic.persistence.storageClass | string | `""` |  |
| statamic.repo.existingSecret | string | `""` |  |
| statamic.repo.knownHosts | string | `""` |  |
| statamic.repo.sshPrivateKey | string | `""` |  |
| statamic.repo.sshUrl | string | `"git@github.com:org/repository.git"` |  |
| statamic.schedule | string | `"*/10 * * * *"` |  |
| webRoot | string | `"/var/www/html"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
