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

# Create the service project, enable needed APIs and mark it as a service project
resource "google_project" "project" {
  count      = length(var.service_projects)
  name       = var.service_projects[count.index].name
  project_id = format("%s-%s",var.service_projects[count.index].name,random_id.random_project_id_suffix.hex)
  folder_id  = var.parent_folder
  billing_account = var.billing_account
}

resource "google_project_services" "project" {
  count    = length(var.service_projects)
  project  = google_project.project[count.index].number
  services = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "oslogin.googleapis.com", "iamcredentials.googleapis.com"]
}

resource "google_compute_shared_vpc_service_project" "service" {
  count           = length(var.service_projects)
  host_project    = var.host_vpc_project_id
  service_project = google_project.project[count.index].number
}

# Within the project, create the network, storage, and compute resources

# Subnets within shared VPC
resource "google_compute_subnetwork" "subnets" {
  count         = length(var.service_projects)
  name          = var.service_projects[count.index].network_resources.subnet_name
  ip_cidr_range = var.service_projects[count.index].network_resources.subnet_cidr
  region        = var.service_projects[count.index].network_resources.subnet_region
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id
}


resource "google_compute_firewall" "firewall-rules" {
  count         = length(var.service_projects)
  name          = var.service_projects[count.index].network_resources.firewall_name
  source_ranges = var.service_projects[count.index].network_resources.source_ranges
  target_tags   = var.service_projects[count.index].network_resources.target_tags
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id

  dynamic "allow"{
    for_each = "${var.service_projects[count.index].network_resources.allow}"
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}



/***********

module "storage" {
  source               = "../modules/zfs_fileserver"
  name                 = var.zfs_server_name 
  machine_type         = var.zfs_machine_type
  subnet_name          = local.fileserver_subnet
  project_id           = module.service-project.project_id
/***********

module "storage" {
  source               = "../modules/zfs_fileserver"
  name                 = var.zfs_server_name 
  machine_type         = var.zfs_machine_type
  subnet_name          = local.fileserver_subnet
  project_id           = module.service-project.project_id
  host_project_id      = module.host-project.project_id
  storage_disk_name    = var.zfs_storage_disk_name
  storage_disk_type    = var.zfs_storage_disk_type
  storage_disk_size_gb = var.zfs_storage_size_gb
  zone                 = var.zone
}


module "compute" {
}
***********/
