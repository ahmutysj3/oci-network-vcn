resource "oci_core_security_list" "hub" {
  compartment_id = oci_identity_compartment.network.id
  vcn_id         = oci_core_vcn.hub.id
  for_each       = local.hub_subnets
  display_name   = "${var.dc_name}_${each.key}_sl_pri"

  egress_security_rules { ## egress allow all 
    description = "Allows all egress traffic"
    stateless   = "false"
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  dynamic "ingress_security_rules" { ## allow inbound https from internet (fwmgmt subnet only)
    iterator = sub_sl
    for_each = {
      for subk, sub in local.hub_subnets : subk => sub if subk == each.key && length(regexall("fwmgmt", each.key)) == 1
    }

    content {
      description = "Allows all inbound https traffic"
      stateless   = "false"
      protocol    = "6"
      source      = "0.0.0.0/0"

      tcp_options {
        min = 443
        max = 443
      }
    }
  }

  dynamic "ingress_security_rules" { ## allow all inbound tcp/22 from internet (fwmgmt subnet only)
    iterator = sub_sl
    for_each = {
      for subk, sub in local.hub_subnets : subk => sub if subk == each.key && length(regexall("fwmgmt", each.key)) == 1
    }

    content {
      description = "Allows all inbound ssh/scp traffic"
      stateless   = "false"
      protocol    = "6"
      source      = "0.0.0.0/0"


      tcp_options {
        min = 22
        max = 22
      }
    }
  }


  dynamic "ingress_security_rules" { ## allow all inbound internet traffic from internet (fwoutside subnet only)
    iterator = sub_sl
    for_each = {
      for subk, sub in local.hub_subnets : subk => sub if subk == each.key && length(regexall("fwoutside", each.key)) == 1
    }

    content {
      description = "Allows all inbound traffic"
      stateless   = "false"
      protocol    = "all"
      source      = "0.0.0.0/0"
    }
  }

  dynamic "ingress_security_rules" { ## allow all inbound traffic from within supernet (fwinside subnet only)
    iterator = sub_sl
    for_each = {
      for subk, sub in local.hub_subnets : subk => sub if subk == each.key && length(regexall("fwinside", each.key)) == 1
    }

    content {
      description = "Allows all inbound traffic from within ${var.dc_name} datacenter"
      stateless   = "false"
      protocol    = "all"
      source      = var.supernet_cidr
    }
  }


  dynamic "ingress_security_rules" { # allow all ICMP type 1 from internet (Applies only to fwmgmt subnet)
    iterator = sub_sl
    for_each = {
      for subk, sub in local.hub_subnets : subk => sub if subk == each.key && length(regexall("fwmgmt", each.key)) == 1
    }
    content {
      description = "Allows ICMP from internet"
      stateless   = "true"
      protocol    = "1"
      source      = "0.0.0.0/0"
    }
  }
}