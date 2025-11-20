variable "kubeconfig" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "semaphore"
}

variable "postgres_password" {
  type    = string
  description = "Postgres password - store securely (Vault/TF Cloud secrets)"
  default = "linux123"
}
