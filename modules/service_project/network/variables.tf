
variable "subnet_names" {
  type = list(string)
}

variable "subnet_cidrs" {
  type = list(string)
}

variable "subnet_regions" {
  type = list(string)
}

variable "host_vpc_network" {
  type = string
}

variable "host_vpc_project_id" {
  type = string
}

variable "firewall_names" {
  type = list(string)
}

variable "source_ranges" {
  type = list(list(string))
}

variable "target_tags" {
  type = list(list(string))
}

variable "allows" {
  type = list(list(object({
                     protocol = string
                     ports    = list(string)
  })))
}
