locals {
  credentials_file_path = var.credentials_path
  subnet_01             = "${var.network_name}-license-subnet"
  subnet_02             = "${var.network_name}-fileserver-subnet"
}

// Configure the Google Cloud provider
provider "google" {
 credentials = file(local.credentials_file_path)
 region      = var.region
}

// Create a folder to host all of the resources
resource "google_folder" "servicesfolder" {
  display_name = var.parent_folder_name
  parent       = var.parent_resource_node
}

// Create the  Shared VPC host project and the VPC network
module "host-project" {
  source            = "../modules/host_project"
  folder_id         = "${google_folder.servicesfolder.name}"
  name              = var.host_project_name
  org_id            = var.organization_id
  network_name      = var.network_name
  project_id        = var.host_project_id
  billing_account   = var.billing_account
  region            = var.region
}
