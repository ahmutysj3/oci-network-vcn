resource "oci_core_local_peering_gateway" "hub" {
  for_each       = var.spoke_vcns
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.hub.id
  display_name   = "${var.dc_name}_hub_lpg_to_${each.key}"
  peer_id        = oci_core_local_peering_gateway.spoke[each.key].id
}

resource "oci_core_local_peering_gateway" "spoke" {
  for_each       = var.spoke_vcns
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.spoke[each.key].id
  display_name   = "${var.dc_name}_hub_lpg_to_${each.key}_vcn"
}

resource "oci_core_internet_gateway" "hub" {
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.hub.id
  enabled        = var.internet_gateway_enabled
  display_name   = "${var.dc_name}_hub_igw"
}