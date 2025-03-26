variable "zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
}

variable "name" {
  description = "The name of the record to create (e.g., www.royalreddy.site)"
  type        = string
}

variable "ttl" {
  description = "The time-to-live (TTL) of the record in seconds"
  type        = number
  default     = 300
}

variable "records" {
  description = "The IP addresses or DNS names that the record points to"
  type        = list(string)
}
