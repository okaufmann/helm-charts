# mailpit

A Helm chart for [Mailpit](https://mailpit.axllent.org/) on Kubernetes.

Mailpit is an email testing tool: an SMTP server, a web UI, and an API. There
is no official chart; this one deploys the upstream image.

## Install

```sh
helm repo add olidev https://helm-charts.oli-the.dev
helm install mailpit olidev/mailpit
```

## Values

Put non-secret configuration in `envs` (`MP_*` runtime options). Inject
secrets with `existingEnvSecrets`. The default rollout is `Recreate` so a
single RWO database volume is never mounted by two pods.

The web UI is port `8025`. SMTP is port `1025` on the same Service. Leave
SMTP as ClusterIP unless you add authentication and TLS yourself.

Optional SpamAssassin is gated by `spamassassin.enabled`. When it is on, the
chart sets `MP_ENABLE_SPAMASSASSIN` to the in-chart Service unless you already
set that key in `envs`.

Protect the UI with your ingress controller or a Gateway `ExternalAuth`
filter on `httpRoute`. Mailpit only has optional HTTP basic auth.
`app.ingress` remains the Ingress API.

`httpRoute.listenerSet` adds a ListenerSet with one HTTPS listener per
hostname on the given Gateway. Its `clusterIssuer` annotation makes
cert-manager issue `secretName` (default `<fullname>-tls`) in the release namespace, and
the route attaches to the set unless `parentRefs` is given.

```yaml
envs:
  MP_DATABASE: /data/mailpit.db
  MP_MAX_MESSAGES: "500"
  MP_LABEL: Staging

app:
  ingress:
    enabled: true
    ingressClassName: nginx
    hosts:
      - host: mailpit.example.com
        paths:
          - /
    tls:
      - hosts:
          - mailpit.example.com
        secretName: mailpit-tls

spamassassin:
  enabled: true
```
