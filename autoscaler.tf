
# Kubernetes HPA
resource "kubernetes_horizontal_pod_autoscaler" "wordpress_autoscaler" {
  metadata {
    name = "wordpress"
  }

  depends_on = [ kubernetes_deployment.wordpress_deployment ]

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "wordpress-deployment"
    }

    min_replicas = 2
    max_replicas = 4

    target_cpu_utilization_percentage = var.pod-cpu-utilization-percentage-treshold
  }
}