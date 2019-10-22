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
  project_id_base  = var.host_project.project_id_base
  parent_folder    = google_folder.servicesfolder.name
  billing_account  = var.billing_account
}

module "license_project"{
  source              = "../modules/license_project"
  billing_account     = var.billing_account
  host_vpc_project_id = module.host_project.project_id
  host_vpc_network    = var.host_project.network_name
  parent_folder       = google_folder.servicesfolder.name
  license_project     = var.license_project
}

// Create the service projects and their associated resources
module "user_projects"{
  source              = "../modules/user_projects"
  billing_account     = var.billing_account
  host_vpc_project_id = module.host_project.project_id
  host_vpc_network    = var.host_project.network_name
  parent_folder       = google_folder.servicesfolder.name
  service_projects    = var.user_projects
}
