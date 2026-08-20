# Helm Chart for hcloud-csi-driver

> **DEPRECATED:** This community chart is no longer maintained and should not be used for new installations.
> Please use the official Hetzner Cloud CSI Helm chart from [https://charts.hetzner.cloud](https://charts.hetzner.cloud) instead.

Hetzner now publishes an official chart for the CSI driver. Install that one:

```
helm repo add hcloud https://charts.hetzner.cloud
helm repo update hcloud
helm install hcloud-csi hcloud/hcloud-csi -n kube-system
```

See the [official CSI driver documentation](https://github.com/hetznercloud/csi-driver) for requirements and configuration.

If you are still running this community chart, migrate to `hcloud/hcloud-csi` and then uninstall this release.
