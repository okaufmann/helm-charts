# node-app

A Helm chart for running Node.js HTTP applications (Nuxt, Nitro, and similar)
on Kubernetes.

## Install

```sh
helm repo add olidev https://helm-charts.oli-the.dev
helm install my-app olidev/node-app
```

## Values

Put non-secret configuration in `envs`. Inject secrets with
`existingEnvSecrets`. The default rollout is `RollingUpdate` with
`maxUnavailable: 0`. Liveness uses `/health`; startup and readiness use
`/ready` so a warmup can finish before the pod takes traffic.

Optional Valkey is the Bitnami subchart, gated by `valkey.enabled`.

`httpRoute` attaches the release to a Gateway. `app.ingress` remains the
Ingress API. `httpRoute.uptimeBridge` adds an Ingress of class `uptime-only`
with `tls.hosts` and no secret.
