# Generic Helm Chart for Laravel Applications

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



