#This is modified from https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#image
#Explains how we can modify.


resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["Name", "Vilas"]

  boot_disk {
    initialize_params {
      image = "fedora-cloud/fedora-cloud-38"
	  #"debian-cloud/debian-11"
	  #Refer https://cloud.google.com/compute/docs/images
      labels = {
        my_label = "value"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

}

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

}