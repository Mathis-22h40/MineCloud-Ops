# terraform/main.tf

provider "vmworkstation" {
}

resource "vmworkstation_vm" "minecraft_server" {
    source_vm = "minecloud-base-v1" 
    name      = "prod-minecraft"
    processors = 2 # [cite: 48]
    memory    = 4096 # [cite: 48]
}

output "ip_address" {
    value = vmworkstation_vm.minecraft_server.ip 
}
