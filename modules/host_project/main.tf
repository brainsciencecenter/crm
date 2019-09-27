/* Author : Joseph Schoonover, Fluid Numerics LLC
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/

/*****************************
 VPC Host Project
*****************************/

resource "google_project" "project" {
  name       = var.name
  project_id = var.project_id
  folder_id  = var.folder_id
}

/*****************************
 VPC Network
*****************************/

resource "google_compute_network" "network" {
  name    = var.network_name
  project = var.project_id
  depends_on = [google_project.project]
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = var.project_id
  depends_on = [google_compute_network.network]
}


