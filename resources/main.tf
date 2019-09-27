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
resource "google_folder" "bscservices" {
  display_name = "BSC Services"
  parent = var.parent_folder_id
}

// Create the  Shared VPC host project and the VPC network
module "host-project" {
  source            = "../modules/host_project"
  folder_id         = google_folder.bscservices.id
  name              = var.host_project_name
  org_id            = var.organization_id
  credentials_path  = local.credentials_file_path
  network_name      = var.bsc_vpc_name
  project_id        = var.project_id
}
