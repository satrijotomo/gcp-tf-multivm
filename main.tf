
# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  count = var.vmcount
  name = "vm-pip-${count.index}"
  depends_on = [ google_compute_firewall.ssh-rule ]
}

resource "google_compute_instance" "backendcluster" {
    name = "backendvm-${count.index}"
    count = var.vmcount
    machine_type = "f1-micro"
    tags = ["backend-vm"]
    metadata = {
        ssh-keys = file("~/.ssh/id_rsa.pub")
    }
    
    boot_disk {
        initialize_params {
        image = "centos-cloud/centos-7"
        }
    }

    network_interface {
        # A default network is created for all GCP projects
        network = google_compute_network.vpc_network.self_link
        access_config {
            nat_ip = google_compute_address.static[count.index].address
        }
    }

}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network-2"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "ssh-rule" {
  name = "tf-allow-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  target_tags = ["backend-vm"]
  source_ranges = ["0.0.0.0/0"]
}

resource "null_resource" "prov_apache"{
    count = var.vmcount
    
    triggers = {
        /*cluster_instance_ids = join(",", aws_instance.cluster.*.id)*/
        backend_instance_id = join(",", google_compute_instance.backendcluster.*.id)
    }

    provisioner "remote-exec" {
        connection {
        host        = google_compute_address.static[count.index].address
        type        = "ssh"
        user        = "basatrij"
        timeout     = "50s"
        private_key = file("~/.ssh/id_rsa")
        }
        inline = [
        "sudo yum -y install epel-release",
        "sudo yum -y install nginx",
        "sudo nginx -v",
        ]
    }
}