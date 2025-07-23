# Standalone test that doesn't use the module

variables {
  test_string = "hello world"
  test_number = 42
  test_list   = ["a", "b", "c"]
  test_map    = {
    key1 = "value1"
    key2 = "value2"
  }
}

run "standalone_test" {
  command = plan
  
  module {
    source = "./tests"
  }
  
  assert {
    condition     = var.test_string == "hello world"
    error_message = "Test string does not match expected value"
  }
  
  assert {
    condition     = var.test_number == 42
    error_message = "Test number does not match expected value"
  }
  
  assert {
    condition     = length(var.test_list) == 3
    error_message = "Test list length does not match expected value"
  }
  
  assert {
    condition     = var.test_map.key1 == "value1"
    error_message = "Test map key1 does not match expected value"
  }
}