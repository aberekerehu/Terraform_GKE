
resource "google_sql_database_instance" "master" {
  name             = "${var.database-instance}"
  database_version = "${var.database-version}"
  region           = "me-west1"
  depends_on = [ google_container_cluster.wordpress_cluster ]
  settings {
    tier = "db-n1-standard-1"
    location_preference {
      zone = "me-west1-a"  #
    }
    
    ip_configuration {
      ipv4_enabled    = true
      authorized_networks {
        name   = "allow-from-all"
        value  = "0.0.0.0/0"
      }
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name      = "${var.database-name}"
  instance  = google_sql_database_instance.master.name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "users" {
  name     = "${var.database-username}"
  instance = google_sql_database_instance.master.name
  host     = "%"
  password = "${var.database-password}"
}
