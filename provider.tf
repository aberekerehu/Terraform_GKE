provider "google" {
  credentials = file("${var.target-cloud-credentials}")
  project     = "${var.target-cloud-project-name}"
  region      = "${var.target-cloud-region}" 
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = "wordpress-cluster"
  location = "me-west1-a"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}
