# data "cloudinit_config" "ubuntu_init" {
#   gzip          = true
#   base64_encode = true

#   part {
#     content_type = "text/x-shellscript"
#     content      = templatefile("${path.module}/scripts/webserver.sh", {})
#   }
# }


data "oci_core_images" "ubuntuImage" {
    #Required
    compartment_id = var.sandbox_ocid

    #Optional
    operating_system         = "Canonical Ubuntu"
    operating_system_version = "22.04"
    shape                    = "VM.Standard.E2.1.Micro"



}

output "ubuntuImageId" {
  value = data.oci_core_images.ubuntuImage.images[0].id
}
data "oci_core_images" "oracleImage" {
    #Required
    compartment_id = var.sandbox_ocid

    #Optional
    operating_system         = "Oracle Linux"
    operating_system_version = "8"
    shape                    = "VM.Standard.E2.1.Micro"



}

output "oracleImageId" {
  value = data.oci_core_images.oracleImage.images[0].id
}
data "oci_core_vcns" "getVCN" {
    #Required
    compartment_id = var.sandbox_ocid

    #Optional
    display_name = var.vcn_name
    # state = var.vcn_state
}


data "oci_core_subnets" "getSubnetPublic" {
    #Required
    compartment_id = var.sandbox_ocid

    #Optional
    display_name = var.public_subnet_name
    # state = var.subnet_state
    vcn_id = data.oci_core_vcns.getVCN.virtual_networks[0].id
}

data "oci_core_subnets" "getSubnetPrivate" {
    #Required
    compartment_id = var.sandbox_ocid

    #Optional
    display_name = var.private_subnet_name
    # state = var.subnet_state
    vcn_id = data.oci_core_vcns.getVCN.virtual_networks[0].id
}


output "vncid" {
  value = data.oci_core_vcns.getVCN.virtual_networks[0].id
}

output "PublicSubnetid" {
  value = data.oci_core_subnets.getSubnetPublic.subnets[0].id
}
output "PrivateSubnetid" {
  value = data.oci_core_subnets.getSubnetPrivate.subnets[0].id
}



data "oci_kms_vaults" "myVault" {
    #Required
    compartment_id = var.sandbox_ocid
    #  filter = "name==firstVault"

    filter {
    name   = "display_name"
    values = [var.vaultName]
  }
}

data "oci_vault_secrets" "mySecretid" {
    #Required
    compartment_id = var.sandbox_ocid

    #Optional
    name = "publickey"
    # state = var.secret_state
    vault_id = data.oci_kms_vaults.myVault.vaults[0].id
}

# output "secretid" {


data "oci_secrets_secretbundle" "mySecret" {
  secret_id = data.oci_vault_secrets.mySecretid.secrets[0].id #"ocid1.vaultsecret.oc1.iad.amaaaaaaew7n6oaa6rrvbmjjti3ev3z5urtlw2fdbjhnufrep22mlcl34bja"
}

output "mySecret" {
  value = base64decode(data.oci_secrets_secretbundle.mySecret.secret_bundle_content.0.content)
}