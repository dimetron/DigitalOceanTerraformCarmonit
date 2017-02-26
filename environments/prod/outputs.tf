output "first_consule_node_address" {
  value = "${digitalocean_droplet.docker.0.ipv4_address}"
}

output "all_addresses" {
  value = ["${digitalocean_droplet.docker.*.ipv4_address}"]
}

output "public_ip" {
  value = "${digitalocean_floating_ip.carmonit.ip_address}"
}