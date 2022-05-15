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
  default = "dax@pam!dax_token"
}

variable "pm_api_token_secret" {
  default = "f91733b7-8128-493d-8d52-7634213a3b75"
}