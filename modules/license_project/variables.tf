/* Author : Joseph Schoonover, Fluid Numerics LLC ( Sept. 2019 )
*
*
*  Creates a service project and its resources 
*  
*/

variable "billing_account"{
  type = string
}

variable "host_vpc_project_id"{
  type = string
}


variable "parent_folder" {
  type = string
}

variable "host_vpc_network" {
  type = string
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
