credentials_path      = "TO DO : Enter the full path to the credentials file for your terraform service account"
parent_resource_node  = "TO DO : Enter the resource hierarchy node that host the projects and folders created from these scripts."
billing_account       = "TO DO"

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
