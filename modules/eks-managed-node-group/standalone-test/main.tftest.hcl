# Standalone test that doesn't require AWS provider

# Test with default values
run "default_values" {
  command = plan
  
  assert {
    condition     = var.test_string == "default string"
    error_message = "Test string does not match expected value"
  }
  
  assert {
    condition     = var.test_number == 0
    error_message = "Test number does not match expected value"
  }
  
  assert {
    condition     = length(var.test_list) == 0
    error_message = "Test list length does not match expected value"
  }
  
  assert {
    condition     = length(var.test_map) == 0
    error_message = "Test map length does not match expected value"
  }
}

# Test with custom values
run "custom_values" {
  command = plan
  
  variables {
    test_string = "hello world"
    test_number = 42
    test_list   = ["a", "b", "c"]
    test_map    = {
      key1 = "value1"
      key2 = "value2"
    }
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
    condition     = length(var.test_map) == 2
    error_message = "Test map length does not match expected value"
  }
  
  assert {
    condition     = var.test_map.key1 == "value1"
    error_message = "Test map key1 does not match expected value"
  }
}

# Test local values
run "local_values" {
  command = plan
  
  variables {
    test_string = "hello"
    test_number = 42
    test_list   = ["a", "b", "c"]
    test_map    = {
      key1 = "value1"
      key2 = "value2"
    }
  }
  
  assert {
    condition     = output.combined_string == "hello-42"
    error_message = "Combined string does not match expected value"
  }
  
  assert {
    condition     = output.list_length == 3
    error_message = "List length does not match expected value"
  }
  
  assert {
    condition     = length(output.map_keys) == 2
    error_message = "Map keys length does not match expected value"
  }
  
  assert {
    condition     = contains(output.map_keys, "key1") && contains(output.map_keys, "key2")
    error_message = "Map keys do not match expected values"
  }
}