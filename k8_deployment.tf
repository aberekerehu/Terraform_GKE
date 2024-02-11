resource "kubernetes_deployment" "wordpress_deployment" {
  metadata {
    name = "wordpress-deployment"
  }
  depends_on = [google_sql_database_instance.master, google_container_cluster.wordpress_cluster]
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "wordpress"
      }
    }
    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }
      spec {
        container {
          name  = "wordpress"
          image = "wordpress:latest" 

          dynamic "env" {
            for_each = {
              INSTANCE_CONNECTION_NAME = var.database-connection-name
              WORDPRESS_DB_HOST        = "${google_sql_database_instance.master.public_ip_address}:3306"
              WORDPRESS_DB_USER        = var.database-username
              WORDPRESS_DB_PASSWORD    = var.database-password
              WORDPRESS_DB_NAME        = var.database-name
            }
            content {
              name  = env.key
              value = env.value
            }
          }
          # resources {
          #   limits = {
          #     cpu    = "500m"
          #     memory = "512Mi"
          #   }
          #   requests = {
          #     cpu    = "250m"
          #     memory = "256Mi"
          #   }
          # }
        }
      }
    } 
  }
}
