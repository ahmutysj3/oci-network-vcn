resource "oci_kms_vault" "main" {
    compartment_id = oci_identity_compartment.network.id
    display_name = "${var.dc_name}-main-vault"
    vault_type = "DEFAULT"
}

resource "oci_kms_key" "main" {
    compartment_id = oci_identity_compartment.network.id
    display_name = "${var.dc_name}-main-key"
    key_shape {
        algorithm = "AES"
        length = 32
    }
    management_endpoint = oci_kms_vault.main.management_endpoint
}

