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

service_projects = [
{ name            = "service-project-sandbox"
  parent_folder   = "services"
  network_resources = {
    subnet_name = "subnet1"
    subnet_cidr = "10.10.0.0/16"
    subnet_region = "us-east1"
    firewall_name = "subnet1-firewall"
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["subnet1"]
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
}]
```

Once you have concretized the necessary variables, you can preview the terraform plan.
```
$ terraform init
$ terraform plan -var-file=template.tfvars -out=tfplan
```
Once you are ready to create the resources
```
$ terraform apply "tfplan"
```
