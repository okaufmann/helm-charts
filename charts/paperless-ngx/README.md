# paperless-ngx

A Helm chart for [Paperless-ngx](https://docs.paperless-ngx.com/) on Kubernetes.

## Install

```sh
helm repo add olidev https://helm-charts.oli-the.dev
helm install paperless olidev/paperless-ngx
```

## Values

Put non-secret configuration in `envs`. Inject secrets with
`existingEnvSecrets`. The default rollout is `Recreate` so a single RWO media
volume is never mounted by two pods.

The chart writes `PAPERLESS_REDIS` from `redis.existingSecretPasswordKey` when
that key is set (the password must already be in the pod env). Optional
`oidc.enabled` builds `PAPERLESS_SOCIALACCOUNT_PROVIDERS` the same way.

Optional Valkey is the Bitnami subchart, gated by `valkey.enabled`. Use
`fullnameOverride: valkey` and `redis.host: valkey-primary` to match the
service name.

Mount branding or extra Django apps with `app.extraVolumes` /
`app.extraVolumeMounts`. Keep `enableServiceLinks` false: a Service named
after the app injects `PAPERLESS_PORT=tcp://…`, which Granian treats as its
listen port.
