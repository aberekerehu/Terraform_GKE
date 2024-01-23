########### Wideops - task ###########

/* Task 1
WordPress should be deployed on GKE and 
should scale from 2 to 10 pods depending on CPU usage automatically
*/


# GKE Cluster
resource "google_container_cluster" "wordpress_cluster" {
  name     = var.cluster-name
  location = "${var.target-cloud-region}" 

  node_pool {
    name       = "wordpress-node-pool"
    initial_node_count = 2
    autoscaling {
     
      min_node_count = 2
      max_node_count = 4
    }
    node_config {
      machine_type = "e2-medium" 
    }
  }
  
  timeouts {
    create = "30m"
    update = "20m"
  }

  remove_default_node_pool = true
  deletion_protection = false
}


# Null resource to wait for the GKE cluster to be ready
resource "null_resource" "wait_for_cluster" {
  depends_on = [google_container_cluster.wordpress_cluster]

  provisioner "local-exec" {
    command = "sleep 60"
  }
}


resource "google_sql_database_instance" "master" {
  name             = "${var.database-instance}"
  database_version = "${var.database-version}"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "${var.database-name}"
  instance = google_sql_database_instance.master.name
  charset  = "utf8"
  collation = "utf8_general_ci"

  
}

resource "google_sql_user" "users" {
  name     = "${var.database-username}"
  instance = google_sql_database_instance.master.name
  host     = "%"
  password = "${var.database-password}"
}


resource "kubernetes_deployment" "wordpress_deployment" {
  metadata {
    name = "wordpress-deployment"
  }
  # depends_on = [google_container_cluster.wordpress_cluster]

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
              WORDPRESS_DB_HOST     = "${var.database-host}"
              WORDPRESS_DB_PORT     = "${var.database-port}"
              WORDPRESS_DB_NAME     = "${var.database-name}"
              WORDPRESS_DB_USER     = "${var.database-username}"
              WORDPRESS_DB_PASSWORD = "${var.database-password}"
            }

            content {
              name  = env.key
              value = env.value
            }
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}



resource "kubernetes_service" "wordpress_service" {
  metadata {
    name = "wordpress-service"
  }
  depends_on = [kubernetes_deployment.wordpress_deployment ]
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
  metadata {
    name = "wordpress-ingress"
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

    # tls {
    #   hosts       = ["wideopstask.com"]
    #   secret_name = "wordpress-tls-secret"
    # }
  }
}



/*
# Kubernetes Secret

resource "kubernetes_secret" "tls_secret" {
  metadata {
    name = "wordpress-tls-secret"
  }

  data = {
    tls.crt = filebase64("tls.crt")
    tls.key = filebase64("tls.key")
  }

  type = "kubernetes.io/tls"
}

*/




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






