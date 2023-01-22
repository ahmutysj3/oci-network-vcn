resource "oci_core_vcn" "hub" {
  compartment_id = oci_identity_compartment.network.id
  cidr_block     = var.hub_vcn_cidr
  display_name   = "${var.dc_name}_hub_vcn"
  dns_label      = "hubvcn"
}

resource "oci_core_vcn" "spoke" {
  for_each       = var.spoke_vcns
  compartment_id = oci_identity_compartment.network.id
  cidr_block     = each.value.cidr
  display_name   = "${var.dc_name}_${each.key}_vcn"
  dns_label      = each.key
}