/* Author : Joseph Schoonover, Fluid Numerics LLC
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/


locals {
 subnet_names          = [for proj in var.service_projects : proj.network_resources.subnet_name]
 subnet_cidrs          = [for proj in var.service_projects : proj.network_resources.subnet_cidr]
 subnet_regions        = [for proj in var.service_projects : proj.network_resources.subnet_region]
 subnet_allows         = [for proj in var.service_projects : proj.network_resources.allow]
 firewall_names        = [for proj in var.service_projects : proj.network_resources.firewall_name]
 source_ranges         = [for proj in var.service_projects : proj.network_resources.source_ranges]
 target_tags           = [for proj in var.service_projects : proj.network_resources.target_tags]
 
 storage_server_names  = [for proj in var.service_projects : proj.storage_resources.server_name]
 storage_machine_types = [for proj in var.service_projects : proj.storage_resources.machine_type]
 storage_disk_names    = [for proj in var.service_projects : proj.storage_resources.disk_name]
 storage_disk_types    = [for proj in var.service_projects : proj.storage_resources.disk_type]
 storage_disk_size_gbs = [for proj in var.service_projects : proj.storage_resources.disk_name]
 storage_zones         = [for proj in var.service_projects : proj.storage_resources.zone]


}


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

locals {
  project_id = [for proj in google_project.project : proj.number]
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
module "network_resources" {
  source = "./network"
  subnet_names   = local.subnet_names
  subnet_cidrs   = local.subnet_cidrs
  subnet_regions = local.subnet_regions
  allows         = local.subnet_allows
  firewall_names = local.firewall_names
  source_ranges  = local.source_ranges
  target_tags    = local.target_tags
  host_vpc_network = var.host_vpc_network
  host_vpc_project_id = var.host_vpc_project_id
}


# Create a zfs file server
module "zfs-file-server" {
  source            = "./storage/zfs_fileserver"
  name                 = local.storage_server_names 
  machine_type         = local.storage_machine_types
  subnet_name          = local.subnet_names
  project_id           = local.project_id
  host_vpc_project_id  = var.host_vpc_project_id
  storage_disk_name    = local.storage_disk_names
  storage_disk_type    = local.storage_disk_types
  storage_disk_size_gb = local.storage_disk_size_gbs
  zone                 = local.storage_zones
}

