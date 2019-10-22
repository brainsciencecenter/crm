/* Author : Joseph Schoonover, Fluid Numerics LLC
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/


/******************************************
  Project random id suffix configuration
 *****************************************/
resource "random_id" "random_project_id_suffix" {
  byte_length = 5
}

# Create the host project and associate with a billing account
resource "google_project" "project" {
  name       = var.name
  project_id = format("%s-%s",var.project_id_base,random_id.random_project_id_suffix.hex)
  folder_id  = var.parent_folder
  billing_account = var.billing_account
}


# Enable necessary APIs
resource "google_project_services" "project" {
  project = google_project.project.number
  services   = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "oslogin.googleapis.com", "iamcredentials.googleapis.com"]
}


# Create the network within the project
resource "google_compute_network" "network" {
  name    = var.network_name
  project = google_project.project.project_id
  auto_create_subnetworks = false
  depends_on = [google_project.project,google_project_services.project]
}

# Mark this project as a shared VPC host project
resource "google_compute_shared_vpc_host_project" "host" {
  project = google_project.project.project_id
  depends_on = [google_compute_network.network]
}

