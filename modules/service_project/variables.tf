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

variable "name" {
  type = string
}

variable "parent_folder" {
  type = string
}

variable "host_vpc_network" {
  type = string
}

variable "network_resources" {
  type = list(object({
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
}
