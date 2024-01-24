
resource "google_sql_database_instance" "master" {
  name             = "${var.database-instance}"
  database_version = "${var.database-version}"
  region           = "me-west1"

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
