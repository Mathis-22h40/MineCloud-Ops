packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.1.0"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.0.0"
    }
  }
}

variable "project_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

source "googlecompute" "minecloud" {
  project_id   = var.project_id
  zone         = var.zone
  machine_type = "e2-medium"

  ssh_username = "packer"

  image_name   = "minecloud-base-v1"
  image_family = "minecloud"

  source_image_family     = "ubuntu-2204-lts"
  source_image_project_id = ["ubuntu-os-cloud"]
}

build {
  sources = ["source.googlecompute.minecloud"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3 python3-apt",

      # Remote tmp Ansible simple et writable
      "sudo mkdir -p /tmp/.ansible-tmp",
      "sudo chmod 1777 /tmp/.ansible-tmp"
    ]
  }

  provisioner "ansible" {
    playbook_file = "../ansible/playbook-common.yml"
    user          = "packer"

    ansible_env_vars = [
      "ANSIBLE_CONFIG=../ansible/ansible.cfg",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_REMOTE_TEMP=/tmp/.ansible-tmp",
      "ANSIBLE_SCP_IF_SSH=True"
    ]

    extra_arguments = [
      "-e", "ansible_python_interpreter=/usr/bin/python3",
      "-e", "ansible_remote_tmp=/tmp/.ansible-tmp"
    ]
  }
}

