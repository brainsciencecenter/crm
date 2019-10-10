/* Author : Joseph Schoonover, Fluid Numerics LLC
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/


locals {
 subnet_cidrs          = [for proj in var.service_projects : proj.network_resources.subnet_cidr]
 subnet_regions        = [for proj in var.service_projects : proj.network_resources.subnet_region]
 subnet_allows         = [for proj in var.service_projects : proj.network_resources.allow]
 source_ranges         = [for proj in var.service_projects : proj.network_resources.source_ranges]
 
 storage_server_names  = [for proj in var.service_projects : proj.storage_resources.server_name]
 storage_machine_types = [for proj in var.service_projects : proj.storage_resources.machine_type]
 storage_disk_names    = [for proj in var.service_projects : proj.storage_resources.disk_name]
 storage_disk_types    = [for proj in var.service_projects : proj.storage_resources.disk_type]
 storage_disk_size_gbs = [for proj in var.service_projects : proj.storage_resources.disk_size_gb]
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
  depends_on = [google_project.project]
}

resource "google_compute_shared_vpc_service_project" "service" {
  count           = length(var.service_projects)
  host_project    = var.host_vpc_project_id
  service_project = google_project.project[count.index].number
  depends_on = [google_project_services.project]
}

# Within the project, create the network, storage, and compute resources

# Subnets within shared VPC
resource "google_compute_subnetwork" "subnets" {
  count         = length(var.service_projects)
  name          = "${var.service_projects[count.index].name}-subnet"
  ip_cidr_range = local.subnet_cidrs[count.index]
  region        = local.subnet_regions[count.index]
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id
  depends_on    = [google_compute_shared_vpc_service_project.service]
}


resource "google_compute_firewall" "firewall-rules" {
  count         = length(var.service_projects)
  name          = "${var.service_projects[count.index].name}-firewall"
  source_ranges = local.source_ranges[count.index]
  target_tags   = ["${var.service_projects[count.index].name}"]
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id

  dynamic "allow"{
    for_each = "${local.subnet_allows[count.index]}"
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
  depends_on    = [google_compute_shared_vpc_service_project.service]
}

// ZFS 
resource "google_compute_disk" "zfs-storage-disk" {
  count = length(var.service_projects)
  name  = local.storage_disk_names[count.index]
  type  = local.storage_disk_types[count.index]
  zone  = local.storage_zones[count.index]
  size  = local.storage_disk_size_gbs[count.index]
  physical_block_size_bytes = 4096
  project = local.project_id[count.index]
}


resource "google_compute_instance" "zfs-fileserver" {
  count = length(var.service_projects)
  name         = local.storage_server_names[count.index]
  machine_type = local.storage_machine_types[count.index]
  zone         = local.storage_zones[count.index]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  attached_disk{
    source = google_compute_disk.zfs-storage-disk[count.index].self_link
  }

  labels = {
  }

  network_interface {
    subnetwork = "${var.service_projects[count.index].name}-subnet"
    subnetwork_project = var.host_vpc_project_id

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = file("${path.module}/scripts/zfs-startup-script.py")

  project = local.project_id[count.index]

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
  tags   = ["${var.service_projects[count.index].name}"]

  depends_on = [google_compute_disk.zfs-storage-disk,google_compute_subnetwork.subnets]
}
