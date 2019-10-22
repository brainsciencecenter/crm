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
    project_id           = string
  })
}

variable "service_projects"{
  type = list(object({
    name                 = string
    project_id           = string
    network_resources    = object({
      subnet_cidr      = string
      subnet_region    = string
      source_ranges    = list( string )
      allow            = list(object({
        protocol = string
        ports    = list(string)
      }))
    })
    members = list(string)
  }))
}

