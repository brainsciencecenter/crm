variable "billing_account"{
  type = string
}

variable "services_folder" {
  type = string
}

variable "credentials_path" {
  type = string
}

variable "parent_resource_node" {
  type = string
}

variable "host_project"{
  type = object({
    name                 = string
    network_name         = string
    project_id_base      = string
  })
}

variable "service_projects"{
  type = list(object({
    name                 = string
    network_resources    = list(object({
      subnet_name      = string
      subnet_cidr      = string
      subnet_region    = string
      firewall_name    = string
      source_ranges    = list( string )
      target_tags      = list( string )
      allow            = list(object({
        protocol = string
        ports    = list(string)
      }))
    }))
  }))
}
