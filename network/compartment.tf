resource "oci_identity_compartment" "network" {
    compartment_id = var.tenancy_ocid
    description = "Network Infrastructure"
    name = "network"
}

