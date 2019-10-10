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

variable "license_project"{
  type = object({
    name                 = string
    network_resources    = object({
      subnet_cidr      = string
      subnet_region    = string
      source_ranges    = list( string )
      allow            = list(object({
        protocol = string
        ports    = list(string)
      }))
    })
    compute_resources = list(object({
      server_name  = string
      machine_type = string
      disk_type    = string
      disk_size_gb = number
      zone         = string
    }))
  })
}

variable "user_projects"{
  type = list(object({
    name                 = string
    network_resources    = object({
      subnet_cidr      = string
      subnet_region    = string
      source_ranges    = list( string )
      allow            = list(object({
        protocol = string
        ports    = list(string)
      }))
    })
    storage_resources = object({
      server_name  = string
      machine_type = string
      disk_name    = string
      disk_type    = string
      disk_size_gb = number
      zone         = string
    })
  }))
}

