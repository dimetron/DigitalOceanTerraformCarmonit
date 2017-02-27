#!/bin/sh

cd environments/prod

terraform plan                      \
  -var 'key_path=~/.ssh/id_rsa'     \
  -var do_token=$DIGITALOCEAN_TOKEN \
  -var 'ssh_key_ID=15163'           \
  -var 'region=fra1'

terraform apply                     \
  -var 'key_path=~/.ssh/id_rsa'     \
  -var do_token=$DIGITALOCEAN_TOKEN \
  -var 'ssh_key_ID=15163'           \
  -var 'region=fra1'