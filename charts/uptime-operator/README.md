# uptime-operator

A Helm chart for [uptime-operator](https://github.com/solid3dlab/uptime-operator):
a tiny Go controller that keeps [Uptime Kuma](https://github.com/louislam/uptime-kuma)
HTTP monitors in sync with annotated Ingresses.

## Install

```sh
helm repo add olidev https://helm-charts.oli-the.dev
helm install uptime-operator olidev/uptime-operator --namespace monitoring
```

Provide Kuma credentials with an existing Secret (recommended) or by setting
`secret.create`. The Secret keys default to `url`, `username`, and `password`.
The Kuma account must not have 2FA enabled; Socket.IO login cannot supply TOTP.

```yaml
existingSecret: uptime-operator

staticMonitors:
  - name: Flux webhook
    type: http
    url: https://flux-webhook.example.com/
    interval: 60
    accepted_statuscodes:
      - "404"
    notification: Slack
```

## Ingress annotations

| Annotation | Meaning |
|---|---|
| `uptime-kuma.io/monitor: "true"` | Manage this Ingress |
| `uptime-kuma.io/monitor-interval` | Check interval in seconds (default `60`) |
| `uptime-kuma.io/monitor-group` | Kuma group name |
| `uptime-kuma.io/notification` | Extra Kuma notification channel name(s) |

Managed monitors are tagged `managed-by-uptime-operator`. Manual monitors are
never touched.

## Values

| Key | Default | Description |
|---|---|---|
| `image.repository` | `ghcr.io/solid3dlab/uptime-operator` | Operator image |
| `image.tag` | Chart `appVersion` | Image tag |
| `config.resyncInterval` | `300` | Seconds between full syncs |
| `config.logLevel` | `INFO` | `DEBUG` / `INFO` / `WARN` / `ERROR` |
| `existingSecret` | `uptime-operator` | Secret with Kuma login |
| `secret.create` | `false` | Create a Secret from `secret.url` / `username` / `password` |
| `staticMonitors` | `[]` | Extra monitors mounted at `/config/monitors.yaml` |
| `rbac.create` | `true` | ClusterRole that can list Ingresses |
