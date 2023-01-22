resource "oci_core_network_security_group" "spoke1" {
    for_each = var.nsg_params
    compartment_id = oci_identity_compartment.network.id
    vcn_id = oci_core_vcn.spoke["morty"].id
    display_name = each.key
}

