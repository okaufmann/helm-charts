# Helm Chart for hcloud-csi-driver

This is a community Helm Chart for installing the hcloud-csi-driver in your Hetzner Cloud Kubernetes cluster.
The original sources of the hcloud-csi-driver can be found at
[https://github.com/hetznercloud/csi-driver](https://github.com/hetznercloud/csi-driver).

**Please note**: This project is a community project from a Hetzner customer, published for use by other Hetzner customers.
Neither the author nor this project is affiliated with Hetzner Online GmbH.

## Installation

### Add Helm Repository

```
helm repo add olidev https://helm-charts.oli-the.dev
helm repo update
```

### Install to Kubernetes

In order to install the hcloud-csi-driver successfully, you have to provide a [Hetzner API Token](https://wiki.hetzner.de/index.php/API_access_token), which will reside in a Secret resource within Kubernetes.
For installing this Helm Chart, you can either reuse an existing secret or create a new one.

  * Install without reusing an existing secret:
    ```
    helm install -n kube-system hcloud-csi-driver olidev/hcloud-csi-driver \
      --set secret.hcloudApiToken=<HCLOUD API TOKEN>
    ```
  * Install reusing an existing secret:
    ```
    helm install -n kube-system hcloud-csi-driver olidev/hcloud-csi-driver \
      --set secret.existingSecretName=<EXISTING SECRET NAME>
    ```


## Configuration

To see all available configuration options for a deployment using this helm chart,
please check the [`values.yaml`](https://github.com/okaufmann/helm-charts/tree/main/charts/hcloud-csi-driver/values.yaml) file.