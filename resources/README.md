# crm/resources

This directory hosts the terraform scripts for creating the GCP resources and desired folder hierarchy for the BSC POC project.

## Usage

To use these scripts, edit the provided terraform variables file ( template.tfvars )
```
host_project_name       = "host-project"
parent_folder_name      = "services"
network_name            = "host-network"
region                  = "us-east1"
organization_id         = "TO DO : Enter your GCP Organization ID"
credentials_path        = "TO DO : Enter the full path to the credentials file for your terraform service account"
resources_parent        = "TO DO : Enter the parent node ( either organizations/orgid or folders/foldername ) "
billing_account         = "TO DO : Provide the billing account ID that will be attached to host and service projects"
parent_resource_node    = "TO DO : Enter the resource hierarchy node that host the projects and folders created from these scripts."
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
