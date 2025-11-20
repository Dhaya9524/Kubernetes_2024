terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig  # or use in-cluster config / env
}

provider "helm" {
  kubernetes_config_path = var.kubeconfig
}