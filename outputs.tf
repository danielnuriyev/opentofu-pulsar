output "kubeconfig" {
  description = "Path to the Kind cluster kubeconfig (from opentofu-kind)"
  value       = local.kubeconfig
}

output "verify" {
  description = "Commands to verify Pulsar is running"
  value       = <<-EOT
    export KUBECONFIG=${local.kubeconfig}

    kubectl get pods -n pulsar
    kubectl port-forward -n pulsar svc/pulsar 8080:8080 &
    curl http://localhost:8080/admin/v2/clusters
  EOT
}
