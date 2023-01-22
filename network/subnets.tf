resource "oci_core_subnet" "hub" {
  for_each                   = local.hub_subnets
  display_name               = "${var.dc_name}_${each.key}_subnet_pri"
  compartment_id             = oci_identity_compartment.network.id
  vcn_id                     = oci_core_vcn.hub.id
  cidr_block                 = each.value.cidr
  dns_label                  = each.key
  prohibit_public_ip_on_vnic = each.value.private
  security_list_ids          = [oci_core_security_list.hub[each.key].id]
  route_table_id             = oci_core_route_table.hub.id
}

resource "oci_core_subnet" "spoke" {
  for_each       = var.spoke_subnets
  display_name   = "${var.dc_name}_${each.key}_subnet_pri"
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.spoke[each.value.vcn].id
  cidr_block     = each.value.cidr
  dns_label      = each.key
  freeform_tags = {
    "instance" = "${each.value.instance}"
  }
  prohibit_public_ip_on_vnic = each.value.private
  route_table_id             = oci_core_route_table.spoke[each.value.vcn].id
}