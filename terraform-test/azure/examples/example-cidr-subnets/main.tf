module "subnet_addrs" {
  source = "../../modules/cidr-subnets"

  base_cidr_block = var.base_cidr_block
  networks = [
    {
      name     = "reserved"
      new_bits = 8
    },
    {
      name     = "foo"
      new_bits = 8
    },
    {
      name     = "bar"
      new_bits = 8
    },
    {
      name     = "baz"
      new_bits = 8
    },
    {
      name     = "boop"
      new_bits = 8
    },
  ]
}
