credentials_path      = "TO DO : Enter the full path to the credentials file for your terraform service account"
parent_resource_node  = "TO DO : Enter the resource hierarchy node that host the projects and folders created from these scripts."
billing_account       = "TO DO"

host_project={
  name = "host-project"
  network_name = "bsc-host-network"
  parent_folder = "services"
  project_id_base = "bsc-host"
}

service_projects = [
{ name            = service-project
  parent_folder   = "services"
  network_resources = [
  { subnet_name = "subnet1"
    subnet_cidr = "10.10.0.0/16"
    subnet_region = "us-east1"
    firewall_name = "subnet1-firewall"
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["subnet1"]
    allow = [
    { protocol = "tcp"
      ports    = ["22"]
    }]
  }]
}]
