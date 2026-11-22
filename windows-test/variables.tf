variable "proxmox_endpoint" {
  description = "Proxmox API endpoint URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token (format: user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "discovery"
}

variable "storage_pool" {
  description = "Proxmox storage pool for VM disks, EFI disk and vTPM state. fast-lvm is the 7200 rpm CMR drive; data-lvm is an SMR drive and is too slow for a Windows boot disk."
  type        = string
  default     = "fast-lvm"
}

variable "iso_datastore" {
  description = "Proxmox storage that holds the ISO files"
  type        = string
  default     = "storage"
}

variable "windows_iso" {
  description = "File name of the Windows install ISO inside <iso_datastore>:iso/"
  type        = string
  default     = "iot-ltsc-24h2-trimmed.iso"
}

variable "smbios_uuid" {
  description = "Fixed SMBIOS UUID so restores and clones keep Windows activation. Not a secret."
  type        = string
  default     = "c16fa59a-9fd4-4b4f-8b24-1ecf2eeb04c7"
}
