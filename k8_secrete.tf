# Kubernetes Secret



resource "kubernetes_secret" "tls_secret" {
  metadata {
    name = "wordpress-tls-secret"
  }

  data = {
    "tls.crt" = file("${path.module}/fullchain.pem")
    "tls.key" = file("${path.module}/cert-key.pem")
  }

  type = "kubernetes.io/tls"
}

