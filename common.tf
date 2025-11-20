resource "kubernetes_namespace" "semaphore" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "postgres" {
  name       = "semaphore-postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  namespace  = kubernetes_namespace.semaphore.metadata[0].name
  version    = "15.1.0" # pin a version suitable for your cluster

  values = [
    <<EOF
image:
  tag: "latest" 
yamlencode({
    primary = {
      podSecurityContext = {
        fsGroup = 1001
      }
      containerSecurityContext = {
        runAsUser  = 1001
        runAsGroup = 1001
      }
    }
  })
primary:
  persistence:
    enabled: false
postgresqlPassword: "${var.postgres_password}"
postgresqlDatabase: semaphore
postgresqlUsername: semaphore
EOF
  ]
}

resource "helm_release" "semaphore" {
  name       = "semaphore"
  repository = "https://semaphoreui.github.io/charts"   # official chart repo
  chart      = "semaphore"
  namespace  = kubernetes_namespace.semaphore.metadata[0].name
  version    = "1.0.2"  # example - pin to a known-good chart version

  values = [
    <<EOF
service:
  type: NodePort      # or ClusterIP if you will use an Ingress
image:
  tag: "latest"           # or a pinned tag
database:
  type: postgres
  postgres:
    host: "${helm_release.postgres.name}.semaphore.svc.cluster.local"
    port: 5432
    user: "semaphore"
    dbname: "semaphore"
    password: "${var.postgres_password}"
persistence:
  enabled: false
ingress:
  enabled: false
EOF
  ]
  depends_on = [helm_release.postgres]
}
