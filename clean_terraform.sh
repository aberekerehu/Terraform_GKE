#!/bin/bash

# Remove Terraform state files
rm terraform.tfstate terraform.tfstate.backup

# Remove .terraform directory
rm -rf .terraform

# Remove backup files
rm *.tfbackup

# Remove plan files
rm *.tfplan


echo "Terraform cleanup completed."

# Enable debug mode
# export TF_LOG=DEBUG
# unset TF_LOG

# initialize Terraform with required plugins
terraform init

# Apply terraform configuration
# terraform apply -auto-approve
