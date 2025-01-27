resource "oci_identity_compartment" "compartment" {
    # OCID of ROOT
    compartment_id = var.sandbox_ocid
    description = "COMPARTMENT FOR SANDBOX"
    name = var.compartment_name
}
resource "oci_core_instance" "ubuntu_instance" {
    # Required
    availability_domain = "jPTn:US-ASHBURN-AD-2"
    # availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = oci_identity_compartment.compartment.id
    shape = "VM.Standard.E2.1.Micro"
    source_details {
        source_id = data.oci_core_images.ubuntuImage.images[0].id
        source_type = "image"
    }

    # Optional
    display_name = "firstVM1"
    create_vnic_details {
        assign_public_ip = var.is_private == true ? false : true
        # subnet_id = var.public_subnet_ocid
        subnet_id = var.is_private == true ? data.oci_core_subnets.getSubnetPrivate.subnets[0].id : data.oci_core_subnets.getSubnetPublic.subnets[0].id
    }
    metadata = {
        # ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
        ssh_authorized_keys = base64decode(data.oci_secrets_secretbundle.mySecret.secret_bundle_content.0.content)
    } 
    preserve_boot_volume = false
}