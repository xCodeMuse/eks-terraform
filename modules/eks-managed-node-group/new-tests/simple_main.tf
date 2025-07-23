# Simple main.tf for testing that doesn't require AWS provider

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