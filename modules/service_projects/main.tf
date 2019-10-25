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
}


/******************************************
  Project random id suffix configuration
 *****************************************/

# Create the service project, enable needed APIs and mark it as a service project
resource "google_project" "project" {
  count      = length(var.service_projects)
  name       = var.service_projects[count.index].name
  project_id = var.service_projects[count.index].project_id
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

resource "google_compute_firewall" "internal-firewall-rules" {
  count         = length(var.service_projects)
  name          = "${var.service_projects[count.index].name}-all-internal-firewall"
  source_ranges = [local.subnet_cidrs[count.index]]
  target_tags   = ["${var.service_projects[count.index].name}"]
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id

  allow{
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow{
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow{
    protocol = "icmp"
  }
  depends_on    = [google_compute_shared_vpc_service_project.service]
}

resource "google_compute_router" "router" {
  count         = length(var.service_projects)
  name          = "${var.service_projects[count.index].name}-router"
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id
  region        = local.subnet_regions[count.index]
  depends_on    = [google_compute_subnetwork.subnets]
}

resource "google_compute_router_nat" "nat" {
  count         = length(var.service_projects)
  name          = "${var.service_projects[count.index].name}-router-nat"
  project       = var.host_vpc_project_id
  region        = google_compute_router.router[count.index].region
  router        = google_compute_router.router[count.index].name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
        name                    = google_compute_subnetwork.subnets[count.index].self_link
        source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
    }
}


// IAM Policies
resource "google_project_iam_policy" "project" {
  count = length(var.service_projects)
  project  = local.project_id[count.index]
  policy_data = "${data.google_iam_policy.user[count.index].policy_data}"
}

data "google_iam_policy" "user" {
  count = length(var.service_projects)
  binding {
    role = "organizations/900475861822/roles/BSCInstanceUser"
    members = var.service_projects[count.index].members
  }
  binding { 
    role = "roles/compute.admin"
    members = ["serviceAccount:${local.project_id[count.index]}-compute@developer.gserviceaccount.com"]
  }
}
