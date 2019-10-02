/* Author : Joseph Schoonover, Fluid Numerics LLC ( Sept. 2019 )
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/

variable "billing_account" {
  description = "Billing account ID associated with the host and service projects."
  type        = string
}

variable "folder_id" {
  description = "The name of the folder hosting the resources."
  type        = string
}

variable "name" {
  description = "The name for the project"
  type        = string
}

variable "network_name" {
  description = "The name of the shared VPC network"
  type        = string
}

variable "org_id" {
  description = "The organization ID."
  type        = string
}

variable "project_id" {
  description = "The project id assigned to the service project."
  type        = string
}

variable "host_project_id" {
  description = "The project id assigned to the VPC host project."
  type        = string
}

variable "region" {
  description = "Region where the resources will be deployed"
  type        = "string"
  default     = "us-east1"
}
