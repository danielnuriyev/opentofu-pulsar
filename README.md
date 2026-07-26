# Pulsar on Kind (OpenTofu)

Deploys [Apache Pulsar](https://pulsar.apache.org/) in standalone mode onto the Kind cluster created by [opentofu-kind](https://github.com/danielnuriyev/opentofu-kind).

## Prerequisites

- Kind cluster from `opentofu-kind` (`../opentofu-kind/.kubeconfig` must exist)
- kubectl: `brew install kubectl`
- [OpenTofu](https://opentofu.org/) 1.12.5+: `brew install opentofu`

## Usage

```bash
# Create the Kind cluster first
cd ../opentofu-kind && tofu init && tofu apply

# Deploy Pulsar
cd ../opentofu-pulsar
tofu init
tofu apply
```

## Verify

```bash
export KUBECONFIG=../opentofu-kind/.kubeconfig
kubectl get pods -n pulsar

# REST API
kubectl port-forward -n pulsar svc/pulsar 8083:8080
curl http://localhost:8083/admin/v2/clusters
```

## Cleanup

```bash
tofu destroy   # removes Pulsar from the cluster
```

The Kind cluster is managed separately in `opentofu-kind`.

## Files

| File | Purpose |
|------|---------|
| `main.tf` | Pulsar deployment via kubectl |
| `pulsar.yaml` | Pulsar standalone Kubernetes manifest |
| `outputs.tf` | Kubeconfig path and verify commands |
