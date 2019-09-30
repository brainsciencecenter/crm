
variable "billing_account" {
  description = "Billing account ID associated with the host and service projects."
  type        = string
}

variable "credentials_path" {
  description = "Path to the service account credentials json file."
  type        = string
}

variable "network_name" {
  description = "Name of the shared VPC network."
  type        = "string"
  default     = "host-network"
}

variable "parent_folder_name" {
  description = "Name of the folder that will host the host and service projects."
  type        = "string"
  default     = "services" 
}

variable "region" {
  description = "Region where the resources will be deployed"
  type        = "string"
  default     = "us-east1"
}

variable "host_project_name" {
  description = "Name of the host VPC project"
  type        = "string"
  default     = "host-project"
}

variable "service_project_name" {
  description = "Name of the service project using the shared vpc network"
  type        = "string"
  default     = "service-project"
}

variable "host_project_id" {
  description = "Base name of the host VPC project ID"
  type        = "string"
  default     = "host-project"
}

variable "service_project_id" {
  description = "Base name of the service VPC project ID"
  type        = "string"
  default     = "service-project"
}

variable "organization_id" {
  description = "GCP organzation identification number"
  type        = "string"
}

variable "parent_resource_node" {
  description = "Parent GCP resource node hosting all of the projects and folders created"
  type        = "string"
}

variable "zfs_server_name" {
  description = "The name for the ZFS server"
  type        = string
}

variable "zfs_machine_type"{
  description = "Machine type for the fileserver"
  type        = string
}

variable "zfs_storage_disk_name" {
  description = "The name of the secondary disk for the ZFS fileserver"
  type        = string
}

variable "zfs_storage_disk_type" {
  description = "The type of the secondary disk for the ZFS fileserver"
  type        = string
}

variable "zfs_storage_size_gb" {
  description = "The size (GB) of the secondary disk for the ZFS fileserver"
  type        = string
}

variable "zone" {
  description = "Zone where the resources will be deployed"
  type        = "string"
  default     = "us-east1-b"
}
