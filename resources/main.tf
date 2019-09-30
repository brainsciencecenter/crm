locals {
  credentials_file_path = var.credentials_path
  license_subnet        = "${var.network_name}-license-subnet"
  fileserver_subnet     = "${var.network_name}-fileserver-subnet"
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

// Create the  Shared VPC service project and the VPC network
module "service-project" {
  source            = "../modules/service_project"
  folder_id         = "${google_folder.servicesfolder.name}"
  name              = var.service_project_name
  host_project_id   = module.host-project.project_id
  org_id            = var.organization_id
  network_name      = var.network_name
  project_id        = var.service_project_id
  billing_account   = var.billing_account
  region            = var.region
}

// Create the ZFS File-server
module "zfs-file-server" {
  source            = "../modules/zfs_fileserver"
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
