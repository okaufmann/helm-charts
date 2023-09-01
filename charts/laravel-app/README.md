# laravel-app

![Version: 1.4.13](https://img.shields.io/badge/Version-1.4.13-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for running Laravel Apps on Kubernetes

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
| oci://registry-1.docker.io/bitnamicharts | redis | 18.0.x |

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
| app.extraVolumeMounts | list | `[]` |  |
| app.extraVolumes | list | `[]` |  |
| app.image.pullPolicy | string | `"Always"` |  |
| app.image.repository | string | `"serversideup/php:8.2-fpm-nginx"` |  |
| app.image.tag | string | `"1.0.0"` |  |
| app.ingress.annotations | object | `{}` |  |
| app.ingress.enabled | bool | `false` |  |
| app.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| app.ingress.hosts[0].paths[0] | string | `"/"` |  |
| app.ingress.ingressClassName | string | `""` |  |
| app.ingress.tls[0].hosts[0] | string | `"app.example.com"` |  |
| app.ingress.tls[0].secretName | string | `"app.example.com"` |  |
| app.livenessProbe.httpGet.path | string | `"/health"` |  |
| app.livenessProbe.httpGet.port | int | `80` |  |
| app.livenessProbe.initialDelaySeconds | int | `10` |  |
| app.livenessProbe.periodSeconds | int | `15` |  |
| app.livenessProbe.timeoutSeconds | int | `30` |  |
| app.nodeSelector | object | `{}` |  |
| app.podAnnotations | string | `nil` |  |
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
| global | object | `{}` |  |
| imagePullSecrets[0].name | string | `"regcred"` |  |
| meiliMasterKey | string | `""` |  |
| meiliMasterKeySecretName | string | `"meilisearch-master-key"` |  |
| meilisearch.auth.existingMasterKeySecret | string | `"meilisearch-master-key"` | Use an existing Kubernetes secret for the MEILI_MASTER_KEY |
| meilisearch.enabled | bool | `false` |  |
| meilisearch.environment.MEILI_ENV | string | `"production"` | Sets the environment. Either **production** or **development** |
| meilisearch.environment.MEILI_NO_ANALYTICS | bool | `true` | Deactivates analytics |
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
| queue.enabled | bool | `false` |  |
| queue.extraVolumeMounts | list | `[]` |  |
| queue.extraVolumes | list | `[]` |  |
| queue.image.pullPolicy | string | `"Always"` |  |
| queue.image.repository | string | `"serversideup/php:8.2-fpm-nginx"` |  |
| queue.image.tag | string | `"1.0.0"` |  |
| queue.nodeSelector | object | `{}` |  |
| queue.podAnnotations | string | `nil` |  |
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
| redis.master.persistance.accessModes[0] | string | `"ReadWriteOnce"` |  |
| redis.master.persistance.enabled | bool | `true` |  |
| redis.master.persistance.size | string | `"8Gi"` |  |
| redis.master.persistance.storageClass | string | `""` |  |
| scheduler.affinity | object | `{}` |  |
| scheduler.autoscaling.enabled | bool | `false` |  |
| scheduler.autoscaling.maxReplicas | int | `100` |  |
| scheduler.autoscaling.minReplicas | int | `1` |  |
| scheduler.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| scheduler.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| scheduler.enabled | bool | `false` |  |
| scheduler.extraVolumeMounts | list | `[]` |  |
| scheduler.extraVolumes | list | `[]` |  |
| scheduler.image.pullPolicy | string | `"Always"` |  |
| scheduler.image.repository | string | `"serversideup/php:8.2-fpm-nginx"` |  |
| scheduler.image.tag | string | `"1.0.0"` |  |
| scheduler.nodeSelector | object | `{}` |  |
| scheduler.podAnnotations | string | `nil` |  |
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
| statamic.git.email | string | `"<developers@novu.ch>"` |  |
| statamic.git.message | string | `"Update from production"` |  |
| statamic.git.user | string | `"novu-developers"` |  |
| statamic.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| statamic.persistence.size | string | `"10Gi"` |  |
| statamic.persistence.storageClass | string | `""` |  |
| statamic.repo.knownHosts | string | `""` |  |
| statamic.repo.sshPrivateKey | string | `""` |  |
| statamic.repo.sshUrl | string | `"git@github.com:org/repository.git"` |  |
| statamic.schedule | string | `"*/10 * * * *"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)