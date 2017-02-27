variable "do_token" {}

variable "key_path" {}

variable "ssh_key_ID" {}

variable "region" {}

variable "num_instances" { 
  default  = "1"
}

# 512m 1g 
variable "instance_size" {
  default = "1gb"
}

variable "volume_size" {
  default = 2
}


# Default OS - doctl compute image list | grep docker
variable "image" {
  description = "docker DO image "
  #default     = "docker-16-04"
  default     = "docker"
}