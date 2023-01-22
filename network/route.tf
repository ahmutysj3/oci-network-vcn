resource "oci_core_route_table" "spoke" {
  for_each       = var.spoke_vcns
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.spoke[each.key].id
  display_name   = "${each.key}_main_rt"
  route_rules {
    network_entity_id = oci_core_local_peering_gateway.spoke[each.key].id
    description       = "Routes all ${each.key} traffic to the Hub VCN"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table" "hub_lpg" {
  depends_on = [
    oci_core_local_peering_gateway.hub
  ]
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.hub.id
  display_name   = "${var.dc_name}_hub_lpg_rt"

  dynamic "route_rules" {
    for_each = var.spoke_vcns

    content {
      network_entity_id = oci_core_local_peering_gateway.hub[route_rules.key].id
      description       = "Routes ${route_rules.key} traffic to appropriate LPG"
      destination       = route_rules.value.cidr
      destination_type  = "CIDR_BLOCK"
    }
  }
}

resource "oci_core_route_table" "hub" {
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.hub.id
  display_name   = "${var.dc_name}_hub_main_rt"

  route_rules {
    network_entity_id = oci_core_internet_gateway.hub.id
    description       = "Routes all traffic to IGW"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}