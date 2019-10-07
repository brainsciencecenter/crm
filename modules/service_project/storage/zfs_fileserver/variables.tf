/* Author : Joseph Schoonover, Fluid Numerics LLC ( Sept. 2019 )
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/

variable "name" {
  description = "The name for the ZFS server"
  type        = list(string)
}

variable "machine_type"{
  description = "Machine type for the fileserver"
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of the subnet to deploy the zfs file server"
  type        = list(string)
}

variable "project_id" {
  description = "The project id where the server will be deployed."
  type        = list(string)
}

variable "host_vpc_project_id" {
  description = "The project id assigned to the VPC host project."
  type        = string
}

variable "storage_disk_name" {
  description = "The name of the secondary disk for the ZFS fileserver"
  type        = list(string)
}

variable "storage_disk_type" {
  description = "The type of the secondary disk for the ZFS fileserver"
  type        = list(string)
}

variable "storage_disk_size_gb" {
  description = "The size (GB) of the secondary disk for the ZFS fileserver"
  type        = list(string)
}

variable "zone" {
  description = "Zone where the resources will be deployed"
  type        = list(string)
  default     = ["us-east1-b"]
}
