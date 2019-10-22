# crm/resources

This directory hosts the terraform scripts for creating the GCP resources and desired folder hierarchy for the BSC POC project.

## Pre-requisites
[An excellent tutorial for getting started with resource management with terraform](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform)
Follow the tutorial through the sections

* Set up the environment
* Create the Terraform Admin Project
* Create the Terraform service account

For permissions, the service account will need the following permissions

* Compute Admin ( at parent resource node level or organization level )
* Folder Admin ( at parent resource node level or organization level )
* Billing Account User ( at parent resource node level or organization level )
* Project Creator ( at parent resource node level or organization level )

## Usage

To use these scripts, edit the provided terraform variables file ( template.tfvars )
```
credentials_path      = "TO DO : Enter the full path to the credentials file for your terraform service account"
parent_resource_node  = "TO DO : Enter the resource hierarchy node that host the projects and folders created from these scripts."
billing_account       = "TO DO : Enter the billing account ID that will be used for all host and service project resources"

host_project={
  name = "host-project"
  network_name = "bsc-host-network"
  parent_folder = "services"
  project_id_base = "bsc-host"
}

license_project = {
  name                 = "license"
  network_resources    = {
    subnet_cidr      = "10.10.0.0/16"
    subnet_region    = "us-east1"
    source_ranges    = ["10.20.0.0/16"]
    allow            = [
    { protocol = "tcp"
      ports    = ["27000"]
    }]
  }
  compute_resources = [
    { server_name  = "matlab-flexnet"
      machine_type = "n1-standard-4"
      disk_type    = "pd-standard"
      disk_size_gb = 25
      zone         = "us-east1-b"
    }
  ]
}

user_projects = [
{ name            = "service-project-sandbox"
  parent_folder   = "services"
  network_resources = {
    subnet_cidr = "10.20.0.0/16"
    subnet_region = "us-east1"
    source_ranges = ["0.0.0.0/0"]
    allow = [
    { protocol = "tcp"
      ports    = ["22"]
    }]
  }
  storage_resources = {
    server_name  = "zfs-fileserver"
    machine_type = "n1-standard-4"
    disk_name    = "zfs-fs-storage"
    disk_type    = "pd-standard"
    disk_size_gb = "2000"
    zone         = "us-east1-b"
  }
  members = ["group:my-group@domain.edu"]
}]
```
Note that the `members` field under `user_projects` refers to members being provided the BSC User role.

Once you have concretized the necessary variables, you can preview the terraform plan.
```
$ terraform init
$ terraform plan -var-file=template.tfvars -out=tfplan
```
Once you are ready to create the resources
```
$ terraform apply "tfplan"
```