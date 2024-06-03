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

# create a variable which manages if we should create a volume or not
variable "create_volume" {
  type        = bool
  default     = true
  description = "Whether to create a volume or not"
}

# create a variable which manages if we should create a instance or not
variable "create_instance" {
  type        = bool
  default     = true
  description = "Whether to create an instance or not"
}