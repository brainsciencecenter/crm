credentials_path      = "TO DO : Enter the full path to the credentials file for your terraform service account"
parent_resource_node  = "TO DO : Enter the resource hierarchy node that host the projects and folders created from these scripts."
billing_account       = "TO DO"
services_folder       = "pennbrain-services"

host_project={
  name = "host-project"
  network_name = "bsc-host-network"
  project_id   = "pennbrain-host-3097383fff"
}

service_projects = [
  { name                 = "pennbrain-license"
    project_id           = "pennbrain-license-82eff5"
    network_resources    = {
      subnet_cidr      = "10.10.0.0/16"
      subnet_region    = "us-east1"
      source_ranges    = ["10.20.0.0/16"]
      allow            = [
      { protocol = "tcp"
        ports    = ["27000","27001","1049"]
      }]
    }
    members = ["group:admin@gcp.pennbrain.upenn.edu"]
  },
  { name            = "detre-group"
    project_id      = "detre-group-dd34a9"
    network_resources = {
      subnet_cidr = "10.20.0.0/16"
      subnet_region = "us-east1"
      source_ranges = ["0.0.0.0/0"]
      allow = [
      { protocol = "tcp"
        ports    = ["22"]
      }]
    }
    members = ["group:detre-group@gcp.pennbrain.upenn.edu"]
  }
]
