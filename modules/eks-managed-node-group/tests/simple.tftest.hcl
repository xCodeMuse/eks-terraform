# Simple test that doesn't require AWS resources

# Define a simple variable
variables {
  test_var = "test_value"
}

# Test the variable
run "simple_test" {
  command = plan
  
  assert {
    condition     = var.test_var == "test_value"
    error_message = "Test variable does not match expected value"
  }
}