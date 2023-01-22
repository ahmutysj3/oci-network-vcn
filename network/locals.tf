locals {

  hub_subnets = {
    fwinside = {
      cidr    = "${cidrsubnet("${var.hub_vcn_cidr}", 4, 0)}"
      private = true
    }
    fwoutside = {
      cidr    = "${cidrsubnet("${var.hub_vcn_cidr}", 4, 1)}"
      private = false
    }
    fwmgmt = {
      cidr    = "${cidrsubnet("${var.hub_vcn_cidr}", 4, 2)}"
      private = false
    }
  }
}
