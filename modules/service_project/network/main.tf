
# Subnets within shared VPC
resource "google_compute_subnetwork" "subnets" {
  count         = length(var.subnet_names)
  name          = var.subnet_names[count.index]
  ip_cidr_range = var.subnet_cidrs[count.index]
  region        = var.subnet_regions[count.index]
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id
}


resource "google_compute_firewall" "firewall-rules" {
  count         = length(var.subnet_names)
  name          = var.firewall_names[count.index]
  source_ranges = var.source_ranges[count.index]
  target_tags   = var.target_tags[count.index]
  network       = var.host_vpc_network
  project       = var.host_vpc_project_id

  dynamic "allow"{
    for_each = "${var.allows[count.index]}"
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
}
