variable "template_name" {
  default = "ubuntu-cloudinit-template"
}

variable "proxmox_host" {
  default = "discovery"
}

variable "default_gw" {
  default = "192.168.9.1"
}

variable "pm_api_token_id" {
  description = "Proxmox API token ID (format: user@realm!tokenid)"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}