/* Author : Joseph Schoonover, Fluid Numerics LLC ( Sept. 2019 )
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/

variable "parent_folder"{
  type = string
}

variable "name"{
  type = string
}

variable "billing_account"{
  type = string
}

variable "network_name"{
  type = string
}

variable "project_id"{
  type = string
}

/*
variable "region"{
  type = string
}
*/
