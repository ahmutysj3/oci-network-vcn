variable "spoke_subnets" {
  type = map(object({
    cidr     = string
    private  = bool
    vcn      = string
    instance = string
  }))
}

variable "tenancy" {
  type = string
  sensitive = true
}

variable "spoke_vcns" {
  type = map(object({
    cidr = string
  }))
}

variable "nsg_params" {
  type = map(object({
    rules = map(object({
      description = string
      source_type = string
      allow_from  = string
      ports = map(object({
        protocol = string
        min      = number
        max      = number
        type     = number
        code     = number
      }))
    }))
  }))
}

variable "nsg_vcn" {
  type = map(any)
}
