# Kubernetes Secret

resource "kubernetes_secret" "tls_secret" {
  metadata {
    name = "wordpress-tls-secret"
  }

  data = {
    "tls.crt" = filebase64("./server.crt")
    "tls.key" = filebase64("./server.key")
  }

  type = "kubernetes.io/tls"
}

