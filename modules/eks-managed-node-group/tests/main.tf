# Simple main.tf for testing

variable "test_var" {
  description = "Test variable"
  type        = string
  default     = "default_value"
}

output "test_output" {
  value = var.test_var
}