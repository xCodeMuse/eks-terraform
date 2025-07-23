# Standalone test that doesn't require AWS provider

# Variables for testing
variable "test_string" {
  description = "Test string variable"
  type        = string
  default     = "default string"
}

variable "test_number" {
  description = "Test number variable"
  type        = number
  default     = 0
}

variable "test_list" {
  description = "Test list variable"
  type        = list(string)
  default     = []
}

variable "test_map" {
  description = "Test map variable"
  type        = map(string)
  default     = {}
}

# Local values for testing
locals {
  combined_string = "${var.test_string}-${var.test_number}"
  list_length     = length(var.test_list)
  map_keys        = keys(var.test_map)
}

# Outputs for testing
output "test_string_output" {
  description = "Test string output"
  value       = var.test_string
}

output "test_number_output" {
  description = "Test number output"
  value       = var.test_number
}

output "test_list_output" {
  description = "Test list output"
  value       = var.test_list
}

output "test_map_output" {
  description = "Test map output"
  value       = var.test_map
}

output "combined_string" {
  description = "Combined string output"
  value       = local.combined_string
}

output "list_length" {
  description = "List length output"
  value       = local.list_length
}

output "map_keys" {
  description = "Map keys output"
  value       = local.map_keys
}