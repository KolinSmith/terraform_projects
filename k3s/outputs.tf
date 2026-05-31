output "vm_ips" {
  description = "IP addresses of all k3s VMs"
  value = {
    for k, vm in proxmox_virtual_environment_vm.k3s :
    k => vm.initialization[0].ip_config[0].ipv4[0].address
  }
}

output "control_plane_ip" {
  description = "Control plane IP for k3s join token retrieval"
  value       = "192.168.9.20"
}
