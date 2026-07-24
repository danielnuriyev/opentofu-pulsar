terraform {
  required_version = ">= 1.12.5"

  backend "local" {
    path = ".terraform.tfstate"
  }

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.3.0"
    }
  }
}

locals {
  kubeconfig = "${path.module}/../opentofu-kind/.kubeconfig"
}

resource "null_resource" "pulsar" {
  triggers = {
    manifest      = filemd5("${path.module}/pulsar.yaml")
    kubeconfig    = local.kubeconfig
    manifest_path = "${path.module}/pulsar.yaml"
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail
      test -f "${local.kubeconfig}" || { echo "Kubeconfig not found. Run tofu apply in opentofu-kind first."; exit 1; }
      kubectl --kubeconfig="${local.kubeconfig}" apply -f "${path.module}/pulsar.yaml"
      kubectl --kubeconfig="${local.kubeconfig}" wait --for=condition=ready pod -l app=pulsar -n pulsar --timeout=300s
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kubectl --kubeconfig="${self.triggers.kubeconfig}" delete -f "${self.triggers.manifest_path}" --ignore-not-found --wait=false
    EOT
  }
}
