terraform {
	required_version = ">= 0.8, < 0.9"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

#terraform import -var do_token=$DIGITALOCEAN_TOKEN digitalocean_volume.docker_volume 4b0f9797-fab7-11e6-bedd-000f53303ed0


resource "digitalocean_volume" "docker_volume" {
    region      = "fra1"
    name        = "volume-docker-winterfell${count.index + 1}"
    size        = "${var.volume_size}"
    description = "Docker volume of Winterfell${count.index + 1}"
    count              = "${var.num_instances}"
}

resource "digitalocean_droplet" "docker" {
  image              = "${var.image}"
  region             = "${var.region}"
  size               = "${var.instance_size}"
  name               = "winterfell${count.index + 1}"

  private_networking = true
  volume_ids 		 = ["${digitalocean_volume.docker_volume.*.id}"]
  ssh_keys           = ["${var.ssh_key_ID}"]
  count              = "${var.num_instances}"
  connection {
    type        = "ssh"
    private_key = "${file("${var.key_path}")}"
    user        = "root"
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/debian_upstart.conf"
    destination = "/tmp/upstart.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.num_instances} > /tmp/consul-server-count",
      "echo ${digitalocean_droplet.docker.0.ipv4_address} > /tmp/consul-server-addr",
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/../../scripts/install.sh",
      "${path.module}/../../scripts/service.sh",
      "${path.module}/../../scripts/ip_tables.sh",
    ]
  }
}

#terraform import -var do_token=$DIGITALOCEAN_TOKEN digitalocean_floating_ip.carmonit 46.101.68.36

resource "digitalocean_floating_ip" "carmonit" {
    droplet_id = "${digitalocean_droplet.docker.0.id}"
    region = "${digitalocean_droplet.docker.0.region}"
}

# Create a new domain using DO API
resource "digitalocean_domain" "default" {
    name = "carmonit.com"
    ip_address = "${digitalocean_floating_ip.carmonit.ip_address}"
}