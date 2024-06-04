variable "civo_token" {}

variable "region" {
  type        = string
  default     = "LON1" # or "DG-EXM" or "NYC1"
  description = "The region to provision the cluster against"
}

variable "name_prefix" {
  description = "Prefix to append to the name of the cluster being created"
  type        = string
  default     = "ml-workspace"
}

variable "node_size" {
  type        = string
  default     = "g4g.small" # or an.g1.l40s.x1 or g4g.40.small
  description = "The size of the nodes to provision. Run `civo size list` for all options"
}

variable "drive_size" {
  type        = number
  default     = 100
}

variable "sshkey_id" {
  type        = string
  description = "Uploaded SSH key ID to use for the instance"
}

variable "persistent_volume_id" {
  type        = string
  description = "Created persistent volume to attach to the instance"
}

variable "reserved_ipv4_id" {
  type        = string
  description = "Reserved IP to attach to the instance"
  
}