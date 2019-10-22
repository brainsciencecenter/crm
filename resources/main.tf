// Configure the Google Cloud provider
provider "google" {
 credentials = file(var.credentials_path)
}

// Create a folder to host all of the resources
resource "google_folder" "servicesfolder" {
  display_name = var.services_folder
  parent       = var.parent_resource_node
}

// Create the  Shared VPC host project and the VPC network
module "host_project" {
  source           = "../modules/host_project"
  name             = var.host_project.name
  network_name     = var.host_project.network_name
  project_id       = var.host_project.project_id
  parent_folder    = google_folder.servicesfolder.name
  billing_account  = var.billing_account
}

// Create the service projects and their associated resources
module "service_projects"{
  source              = "../modules/service_projects"
  billing_account     = var.billing_account
  host_vpc_project_id = var.host_project.project_id
  host_vpc_network    = var.host_project.network_name
  parent_folder       = google_folder.servicesfolder.name
  service_projects    = var.service_projects
}
