# cidr-subnets terraform module

This is a simple Terraform module for calculating subnet addresses under a
particular CIDR prefix.

**This module requires Terraform v0.12.10 or later.**

```hcl
module "subnet_addrs" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = "10.0.0.0/8"
  networks = [
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
      new_bits = 4
    },
    {
      name     = "beep"
      new_bits = 8
    },
    {
      name     = "boop"
      new_bits = 8
    },
  ]
}
```

The module assigns consecutive IP address blocks to each of the requested
networks, packing them densely in the address space. The `network_cidr_blocks`
output is then a map from the given `name` strings
to the allocated CIDR prefixes:

```hcl
{
  foo  = "10.0.0.0/16"
  bar  = "10.1.0.0/16"
  baz  = "10.16.0.0/12"
  beep = "10.32.0.0/16"
  boop = "10.33.0.0/16"
}
```

The `new_bits` values are the number of _additional_ address bits to use for
numbering the new networks. Because network `foo` has a `new_bits` of 8,
and the base CIDR block has an existing prefix of 8, its final prefix length
is 8 + 8 = 16. `baz` has a `new_bits` of 8, so its final prefix length is
only 8 + 4 = 12 bits.

If the order of the given networks is significant, the alternative output
`networks` is a list with an object for each requested network that has
the following attributes:

-   `name` is the same name that was given in the request.
-   `new_bits` echoes back the number of new bits given in the request.
-   `cidr_block` is the allocated CIDR prefix for the network.

If you need the CIDR block addresses in order and don't need the names, you
can use `module.subnet_addrs.networks[*].cidr_block` to obtain that
flattened list.

## Changing Networks Later

When initially declaring your network addressing scheme, you can declare your
networks in any order. However, the positions of the networks in the request
list affects the assigned network numbers, so when making changes later it's
important to take care to avoid implicitly renumbering other networks.

The safest approach is to only add new networks to the end of the list and
to never remove an existing network or or change its `new_bits` value. If
an existing allocation becomes obsolute, you can set its name explicitly to
`null` to skip allocating it a prefix but to retain the space it previously
occupied in the address space:

```hcl
module "subnet_addrs" {
  source = "../../modules/cidr-subnets"

  base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name     = null # formerly "foo", but no longer used
      new_bits = 8
    },
    {
      name     = "bar"
      new_bits = 8
    },
  ]
}
```

In the above example, the `network_cidr_blocks` output would have the
following value:

```
{
  bar = "10.1.0.0/16"
}
```

`foo` has been excluded, but its former prefix `10.0.0.0/16` is now skipped
altogether so `bar` retains its allocation of `10.1.0.0/16`.

Because the `networks` output is a list that preserves the element indices
of the requested networks, it _does_ still include the skipped networks, but
with their `name` and `cidr_blocks` attributes set to null:

```
[
  {
    name       = null
    new_bits   = 8
    cidr_block = null
  },
  {
    name       = "bar"
    new_bits   = 8
    cidr_block = "10.1.0.0/16"
  },
]
```

We don't recommend using the `networks` output when networks are skipped in
this way, but if you _do_ need to preserve the indices while excluding the
null items you could use a `for` expression to project the indices into
attributes of the objects:

```
[
  for i, n in module.subnet_addrs.networks : {
    index      = i
    name       = n.name
    cidr_block = n.cidr_block
  }
  if n.cidr_block != null
]
```

Certain edits to existing allocations are possible without affecting
subsequent allocations, as long as you are careful to ensure that the new
allocation occupies the same address space as whatever replaced it.

For example, it's safe to replace a single allocation anywhere in the
list with a pair of consecutive allocations whose `new_bits` value is one
greater. If you have an allocation with `new_bits` set to 4, you can replace
it with two allocations that have `new_bits` set to 5 as long as those two
new allocations retain their position in the overall list:

```hcl
  networks = [
    # "foo-1" and "foo-2" replace the former "foo", taking half of the
    # former address space each: 10.0.0.0/17 and 10.0.128.0/17, respectively.
    {
      name     = "foo-1"
      new_bits = 9
    },
    {
      name     = "foo-2"
      new_bits = 9
    },

    # "bar" is still at 10.1.0.0/16
    {
      name     = "bar"
      new_bits = 8
    },
  ]
```

When making in-place edits to existing networks, be sure to verify that the
result is as you expected using `terraform plan` before applying, to avoid
disruption to already-provisioned networks that you want to keep.

## Example

The following sections show how you might use a result from this module to
declare real network subnets.

`module.subnet_addrs` in the following examples represent references to the
declared module. You are free to name the module whatever makes sense in your
context, but the names must agree between the declaration and the references.

### Microsoft Azure Virtual Networks

```hcl
module "subnet_addrs" {
  source = "../../modules/cidr-subnets"

  base_cidr_block = "10.0.0.0/16"
  networks = [
    {
      name     = "foo"
      new_bits = 8
    },
    {
      name     = "bar"
      new_bits = 8
    },
  ]
}

resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "West US"
}

resource "azurerm_virtual_network" "example" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  name          = "example"
  address_space = [module.subnet_addrs.base_cidr_block]

  dynamic "subnet" {
    for_each = module.subnet_addrs.network_cidr_blocks
    content {
      name           = subnet.key
      address_prefix = subnet.value
    }
  }
}
```

## Network Allocations in a CSV file

It may be convenient to represent your table of network definitions in a CSV
file rather than writing them out as object values directly in the Terraform
configuration, because CSV allows for a denser representation of such a table
that might be easier to quickly scan.

You can create a CSV file `subnets.csv` containing the following and place
it inside your own calling module:

```
"name","newbits"
"foo","8"
"","8"
"baz","8"
```

Since CSV cannot represent null, we will use the empty string to represent an
obsolete network that must still have reserved address space. When editing
the CSV file after the resulting allocations have been used, be sure to keep
in mind the restrictions under
[_Changing Networks Later_](#changing-networks-later) above.

We can use Terraform's `csvdecode` function to parse this file and pass the
result into the CIDR Subnets Module:

```hcl
module "subnet_addrs" {
  source = "../../modules/cidr-subnets"

  base_cidr_block = "10.0.0.0/16"
  networks = [
    for r in csvdecode(file("${path.module}/subnets.csv")) : {
      name     = r.name != "" ? r.name : null
      new_bits = tonumber(r.new_bits)
    }
  ]
}
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name    | Version  |
| ------- | -------- |
| azurerm | >= 2.0.0 |

## Inputs

| Name            | Description                                                                                                                                                                        | Type                                                 | Default | Required |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- | ------- | :------: |
| base_cidr_block | A network address prefix in CIDR notation that all of the requested subnetwork prefixes will be allocated within                                                                   | `string`                                             | n/a     |   yes    |
| networks        | A list of objects describing requested subnetwork prefixes. new_bits is the number of additional network prefix bits to add, in addition to the existing prefix on base_cidr_block | `list(object({ name = string, new_bits = number }))` | n/a     |   yes    |

## Outputs

| Name                | Description                                                                                                                                                                            |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| network_cidr_blocks | A map from network names to allocated address prefixes in CIDR notation                                                                                                                |
| networks            | A list of objects corresponding to each of the objects in the input variable `networks`, each extended with a new attribute `cidr_block` giving the network's allocated address prefix |
| base_cidr_block     | Echoes back the `base_cidr_block` input variable value, for convenience if passing the result of this module elsewhere as an object                                                    |

<!--- END_TF_DOCS --->
