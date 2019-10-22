/* Author : Joseph Schoonover, Fluid Numerics LLC ( Sept. 2019 )
*
*
*  Creates a service project and its resources 
*  
*/

variable "billing_account"{
  type = string
  description = "example"
}

variable "host_vpc_project_id"{
  type = string
  description = "example"
}


variable "parent_folder" {
  type = string
}

variable "host_vpc_network" {
  type = string
}

variable "service_projects" {
  type = list(object({
    name              = string
    project_id        = string
    network_resources = object({
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
  description = "An object describing a list of service projects and its resources"
}
