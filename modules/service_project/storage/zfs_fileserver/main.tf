/* Author : Joseph Schoonover, Fluid Numerics LLC
*
*
*  Creates a shared VPC host project within a folder. 
*  A Shared VPC Network is created within this project.
*  
*  In a future version, we will add iam policies for the bsc-admin  role to align with bsc-admins@<domain>
*/

resource "google_compute_disk" "zfs-storage-disk" {
  name  = var.storage_disk_name
  type  = var.storage_disk_type
  zone  = var.zone
  physical_block_size_bytes = 4096
  project = var.project_id
}


resource "google_compute_instance" "zfs-fileserver" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  attached_disk{
    source = google_compute_disk.zfs-storage-disk.self_link
  }

  labels = {
  }

  network_interface {
    subnetwork = var.subnet_name
    subnetwork_project = var.host_project_id

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = file("${path.module}/startup-script.py")

  project = var.project_id

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

