# example module usage

A Terraform plan for testing the cidr-subnets terraform module.

## Background

This is an example root terraform plan designed to be an example and a method for testing various terraform modules.

## Implementation

Change the module and variable values required for the module in the `main.tf` file. the following steps:

1. Create a `terraform.tfvars` file containing the variables defined in `variables.tf` and their values.

```hcl
base_cidr_block = "10.32.0.0/8"
```

2. Initialize the Terraform provider.

```bash
$ terraform init
```

3. Validate the Terraform plan.

```bash
$ terraform plan
```

4. Implement the Terraform plan.

```bash
$ terraform apply
```

Example output:

```bash
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

base_cidr_block = "10.32.0.0/8"
network_cidr_blocks = tomap({
  "bar" = "10.1.1.0/24"
  "baz" = "10.1.2.0/24"
  "boop" = "10.1.3.0/24"
  "foo" = "10.1.0.0/24"
  "vnet" = "10.0.0.0/16"
})
networks = tolist([
  {
    "cidr_block" = "10.0.0.0/16"
    "name" = "vnet"
    "new_bits" = 8
  },
  {
    "cidr_block" = "10.1.0.0/24"
    "name" = "foo"
    "new_bits" = 16
  },
  {
    "cidr_block" = "10.1.1.0/24"
    "name" = "bar"
    "new_bits" = 16
  },
  {
    "cidr_block" = "10.1.2.0/24"
    "name" = "baz"
    "new_bits" = 16
  },
  {
    "cidr_block" = "10.1.3.0/24"
    "name" = "boop"
    "new_bits" = 16
  },
])
```

<!--- BEGIN_TF_DOCS --->

## Providers

| Name | Version  |
| ---- | -------- |
| null | >= 3.1.0 |

## Inputs

| Name            | Description                                                                                                      | Type     | Default      | Required |
| --------------- | ---------------------------------------------------------------------------------------------------------------- | -------- | ------------ | :------: |
| base_cidr_block | A network address prefix in CIDR notation that all of the requested subnetwork prefixes will be allocated within | `string` | `10.0.0.0/8` |   yes    |

## Outputs

| Name                | Description                                                                                                                                                                            |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| network_cidr_blocks | A map from network names to allocated address prefixes in CIDR notation                                                                                                                |
| networks            | A list of objects corresponding to each of the objects in the input variable `networks`, each extended with a new attribute `cidr_block` giving the network's allocated address prefix |
| base_cidr_block     | Echoes back the `base_cidr_block` input variable value, for convenience if passing the result of this module elsewhere as an object                                                    |

<!--- END_TF_DOCS --->
