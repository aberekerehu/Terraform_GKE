module-version = "1.0"

target-cloud-project-name = "wideops-terraform-provisioning"
target-cloud-region = "me-west1-a"
target-cloud-credentials = "./wideops-terraform-provisioning-e7cac86a62b9.json"


cluster-name = "wordpress-cluster"
#treshold for the kubernetes horizontal pod autoscaler
pod-cpu-utilization-percentage-treshold = 50

database-instance = "wideops-wordpress-sql-instance"
database-connection-name = "google_sql_database_instance.instance.public_ip_address"
database-port = 3306
database-name = "wideops"
database-username = "admin"
database-password = "admin123"
database-version = "MYSQL_8_0"

