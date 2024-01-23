variable "module-version" {
  type        = string
  description = "Version of this Terraform module"
}

variable "target-cloud-project-name" {
  type        = string
  description = "Target environment project  name"
}

variable "target-cloud-region" {
  type        = string
  description = "Target environment desired region"
}

variable "target-cloud-credentials" {
  type        = string
  description = "Target cloud credentials"
}
variable "pod-cpu-utilization-percentage-treshold" {
  type        = number
  description = "Target CPU utilization percentage fot autoscaling"
}


variable "cluster-name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "wordpress-cluster"
}

variable "database-instance" {
  type        = string
  description = "DB instance name"
}

variable "database-host" {
  type        = string
  description = "DB host"
}
variable "database-port" {
  type        = number
  description = "DB port"
}
variable "database-name" {
  type        = string
  description = "DB Name"
}

variable "database-username" {
  type        = string
  description = "DB Username"
}

variable "database-password" {
  type        = string
  description = "DB Password"
}
variable "database-version" {
  type        = string
  description = "DB version"
}
 