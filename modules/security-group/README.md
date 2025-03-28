### Security Group Configuration
## Inputs
| Name          | Description                 | Type   | Example |
|--------------|-----------------------------|--------|---------|
| `name`       | Security Group name         | string | `my-security-group` |
| `vpc_id` | provide vpc_id(string) | string | "vpc-adfg" |
| `description` | Security Group description | string | `Allow traffic` |
| `ingress_rules` | Ingress rules (map) | map(object) | See below |
| `egress_rules` | Egress rules (map) | map(object) | See below |
| `tags`       | Tags for Security Group     | map(string) | `{ Name = "SG", Managed_By = "Terraform" }` |

#### Example: Ingress Rules
```hcl
variable "security_group_ingress" {
  default = {
    key1 = {  # Required
        cidr_ipv4    = "0.0.0.0/0"
        from_port    = 22
        ip_protocol  = "tcp"
        to_port      = 22
    }
    key2 = {  # Optional
        cidr_ipv4    = "0.0.0.0/0"
        from_port    = 80
        ip_protocol  = "tcp"
        to_port      = 80
    }
    key3 = {  # Allow all traffic if required
        cidr_ipv4    = "0.0.0.0/0"
        ip_protocol  = "-1"
    }
  }
}
```

#### Example: Egress Rules
```hcl
variable "security_group_egress_config" {
  default = {
    egress_rule1 = {
        cidr_ipv4   = "0.0.0.0/0"
        ip_protocol = "-1"
    }
  }
}
```

## Outputs
| Name               | Description                        |
|--------------------|----------------------------------|
| `security_group_id` | ID of the created Security Group |