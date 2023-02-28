resource "oci_identity_compartment" "network" {
    compartment_id = var.tenancy
    description = "Network Infrastructure"
    name = "network"
}

