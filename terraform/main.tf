# terraform/main.tf

# Exemple pour VMware Workstation (provider local simple)
# Si tu n'as pas vSphere, Terraform sur VMware Workstation est limité.
# Le plus simple pour le TP est de simuler ou d'utiliser le provider "vmworkstation" si tu l'as installé.

provider "vmworkstation" {
    # Configuration locale
}

resource "vmworkstation_vm" "minecraft_server" {
    source_vm = "minecloud-base-v1" # L'image créée par Packer [cite: 47]
    name      = "prod-minecraft"
    processors = 2 # [cite: 48]
    memory    = 4096 # [cite: 48]
}

output "ip_address" {
    value = vmworkstation_vm.minecraft_server.ip # [cite: 49]
}
