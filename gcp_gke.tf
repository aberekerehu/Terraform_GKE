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
    name               = "wordpress-node-pool"
    initial_node_count = 2
    autoscaling {
      min_node_count = 2
      max_node_count = 10
    }
    node_config {
      machine_type = "e2-medium" 
    }
  }
  timeouts {
    create = "30m"
    update = "20m"
  }
  #remove_default_node_pool = true
  deletion_protection = false
}















