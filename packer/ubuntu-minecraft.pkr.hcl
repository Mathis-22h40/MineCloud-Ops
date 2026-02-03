# packer/ubuntu-minecraft.pkr.hcl

packer {
  required_plugins {
    vmware = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/vmware"
    }
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "vmware-iso" "ubuntu" {
  # Configuration pour VMware Workstation / Player
  iso_url          = "https://releases.ubuntu.com/22.04/ubuntu-22.04.3-live-server-amd64.iso"
  iso_checksum     = "file:https://releases.ubuntu.com/22.04/SHA256SUMS"
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"
  shutdown_command = "echo 'ubuntu' | sudo -S shutdown -P now"
  
  vm_name          = "minecloud-base-v1" 
  cpus             = 2
  memory           = 4096
  disk_size        = 20000
  headless         = false
  
  boot_command = [
    "<wait>c<wait>linux /casper/vmlinuz --- autoinstall<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
}

build {
  sources = ["source.vmware-iso.ubuntu"]

  
  provisioner "ansible" {
    playbook_file = "../ansible/playbook_packer.yml" 
    user          = "ubuntu"
  }
}
