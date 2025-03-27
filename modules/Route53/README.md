# Terraform Route 53 Module

This Terraform module manages Route 53 DNS records in AWS, allowing you to create and manage DNS records such as A or CNAME records in a specific Route 53 hosted zone. It supports setting TTL (Time To Live) and multiple records, such as IP addresses or CNAMEs.

# Features

-> Route 53 Record Creation: Create A records or CNAME records in AWS Route 53.

-> Customizable Record: Allows setting custom record names, TTL, and record values (IP addresses or DNS names).

-> Flexible Input Variables: Provides configurable input options such as zone ID, record name, TTL, and records.

-> Outputs: Exposes useful outputs like record name and IP addresses for easy reference in your Terraform configurations.

# Architecture

This module provisions a DNS record in AWS Route 53, a managed DNS service by Amazon. It uses the aws_route53_record resource to create a record in an existing hosted zone. The DNS record can point to IP addresses (A record) or CNAMEs (CNAME record).

# Module Components:

1. aws_route53_record: The core resource that defines the DNS record within the specified Route 53 hosted zone.

2. Input Variables: Allow customization of record properties such as zone_id, name, ttl, and records.

3. Outputs: Expose the record's name and IP addresses for further use.

# Module Usage

Example: Creating a Route 53 Record

```css
module "route53_record" {
  source   = "path_to_this_module"
  
  zone_id  = "your-zone-id"
  name     = "www.example.com"
  ttl      = 300
  records  = ["192.0.2.1", "192.0.2.2"]
}

```

Example Terraform Configuration (main.tf)

```css
module "route53_record" {
  source   = "path_to_this_module"
  
  zone_id  = "your-zone-id"
  name     = "www.example.com"
  ttl      = 300
  records  = ["192.0.2.1", "192.0.2.2"]
}

output "route53_record_name" {
  value = module.route53_record.route53_record_name
}

output "route53_record_ip" {
  value = module.route53_record.route53_record_ip
}
```

# Inputs

The module accepts the following input variables:

zone_id: The ID of the Route 53 hosted zone where the DNS record will be created.

Type: string

Required: Yes

name: The name of the DNS record to be created (e.g., www.example.com).

Type: string

Required: Yes

ttl: The time-to-live (TTL) value for the record in seconds. The default is 300 seconds (5 minutes).

Type: number

Default: 300

records: The IP addresses or DNS names that the record points to. This can be a list of IPs for an A record or DNS names for a CNAME record.

Type: list(string)

Required: Yes

# Example Input Variables

```css
zone_id = "your-zone-id"
name = "www.example.com"
ttl = 300
records = ["192.0.2.1", "192.0.2.2"]
```

# Outputs

The module provides the following output values:

route53_record_name: The name of the Route 53 record created (e.g., www.example.com).

Type: string

route53_record_ip: The list of IP addresses or DNS names the Route 53 record points to.

Type: list(string)

# Example Output Values

```css
route53_record_name = "www.example.com"
route53_record_ip = ["192.0.2.1", "192.0.2.2"]
```

# Example Full Terraform Configuration

```css
module "route53_record" {
  source   = "path_to_this_module"
  
  zone_id  = "your-zone-id"
  name     = "www.example.com"
  ttl      = 300
  records  = ["192.0.2.1", "192.0.2.2"]
}

output "route53_record_name" {
  value = module.route53_record.route53_record_name
}

output "route53_record_ip" {
  value = module.route53_record.route53_record_ip
}
```

# Breakdown of Sections:

1. Features:

Describes the capabilities of the module, such as DNS record creation, flexible TTL configuration, and outputs for easy access to record details.

2. Architecture:

Explains how the module provisions a DNS record in AWS Route 53, highlighting the key components like aws_route53_record and input/output variables.

3. Usage:

Provides an example configuration on how to use the module within a Terraform project.

4. Inputs:

Lists and explains the input variables required by the module, such as zone_id, name, ttl, and records.

5. Outputs:

Describes the output variables that the module generates, such as the record name and IP addresses.





