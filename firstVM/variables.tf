variable "sandbox_ocid" {
  type = string
}

# variable "public_subnet_ocid" {
#   type = string
# }



variable "compartment_name" {
  type = string
}

variable "vcn_name" {
  type = string
}

variable "public_subnet_name" {
  type = string
}
variable "private_subnet_name" {
  type = string
}
variable "is_private" {
  type    = bool
}

variable "vaultName" {
  type    = string
}