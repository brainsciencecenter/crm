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
  byte_length = 3
}

# Create the service project, enable needed APIs and mark it as a service project
resource "google_project" "project" {
  name       = var.license_project.name
  project_id = format("%s-%s",var.license_project.name,random_id.random_project_id_suffix.hex)
  folder_id  = var.parent_folder
  billing_account = var.billing_account
}

locals {
  project_id = google_project.project.number
}

resource "google_project_services" "project" {
  count    = length(var.license_project)
  project  = google_project.project.number
  services = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "oslogin.googleapis.com", "iamcredentials.googleapis.com"]
}

resource "google_compute_shared_vpc_service_project" "service" {
  count           = length(var.license_project)
  host_project    = var.host_vpc_project_id
  service_project = google_project.project.number
}

# Within the project, create the network, storage, and compute resources

# Subnets within shared VPC
resource "google_compute_subnetwork" "subnets" {
  name          = var.license_project.network_resources.subnet_name
  ip_cidr_range = var.license_project.network_resources.subnet_cidr
  region        = var.license_project.network_resources.subnet_region
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id
}


resource "google_compute_firewall" "firewall-rules" {
  name          = var.license_project.network_resources.firewall_name
  source_ranges = var.license_project.network_resources.source_ranges
  target_tags   = var.license_project.network_resources.target_tags
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id

  dynamic "allow"{
    for_each = "${var.license_project.network_resources.allow}"
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}

# Create the license servers
resource "google_compute_instance" "license-servers" {
  count        = length(var.license_project.compute_resources)
  name         = var.license_project.compute_resources[count.index].server_name
  machine_type = var.license_project.compute_resources[count.index].machine_type
  zone         = var.license_project.compute_resources[count.index].zone

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = var.license_project.compute_resources[count.index].disk_size_gb
      type  = var.license_project.compute_resources[count.index].disk_type
    }
  }

  labels = {
  }

  network_interface {
    subnetwork = var.license_project.network_resources.subnet_name
    subnetwork_project = var.host_vpc_project_id

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  project = local.project_id

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
  tags   = var.license_project.network_resources.target_tags
}

