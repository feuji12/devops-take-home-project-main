This project involves using Terraform to create resources in AWS. As such, you will need an AWS account to work with, as well as the appropriate development tools installed (Terraform CLI, your preferred code editor, etc.)

---

In this codebase, you are given a basic Terraform project that uses the AWS provider. As a starting point, a VPC resource is defined for you.

The AWS region and the VPC CIDR block are configured through input variables. These input variables contain default values, but you may override the variables if you wish.

Your task is to create one public subnet and one private subnet in the given VPC.

**Acceptance Criteria**:

- There exists two subnets, one public and one private, in the given VPC:
  - The subnet CIDR blocks are dynamically generated, based on the VPC CIDR. You are encouraged to use helpers to calculate the subnet CIDRs, such as the external module [hashicorp/subnets/cidr](https://registry.terraform.io/modules/hashicorp/subnets/cidr/latest).
  - The subnet netmask length must be 24.
  - The public subnet must be accessible by the public internet. In other words, this subnet must route to an internet gateway.
  - The private subnet must not be accessible by the public internet.
  - Both subnets must be in the same Availability Zone (AZ). The AZ must not be hardcoded.
- Use the [cloudposse/label/null](https://registry.terraform.io/modules/cloudposse/label/null/latest) module to name your resources, following the naming conventions for the VPC as closely as possible.
  - Any resource that accepts tags must be tagged using the `cloudposse/label/null` module.

If any requirement is unclear, make a reasonable assumption and note your assumption in your solution.

**Deliverables**:

- An updated version of this code repository that satisfies the acceptance criteria above.

Good luck!
