terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.25.2"  # Replace with the desired version
    }
  }
}
resource "kubernetes_service" "wordpress_service" {
  metadata {
    name = "wordpress-service"
  }
  spec {
    selector = {
      app = "wordpress"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
  timeouts {
    create = "20m"
  }
}
//Wait For LoadBalancer to Register IPs
resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on      = [kubernetes_deployment.wordpress_deployment ]
}

/*
The WordPress website should be exposed with an ingress with HTTP and HTTPS (a self-signed certificate can be used for HTTPS)
*/


# Kubernetes Ingress
resource "kubernetes_ingress_v1" "wordpress_ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "wordpress-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/proxy-body-size" = "50m"
      
    }
  }
  spec {
    rule {
      host = "wideopstask.com"
    
      http {
        path {
          path = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "wordpress-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = ["wideopstask.com"]
      secret_name = "wordpress-tls-secret"
    }
  }
}
