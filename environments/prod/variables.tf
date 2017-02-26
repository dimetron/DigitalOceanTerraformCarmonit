variable "do_token" {}

variable "key_path" {}

variable "ssh_key_ID" {}

variable "region" {}

variable "num_instances" {}

# Default OS

variable "image" {
  description = "docker DO image "
  default     = "docker"
}