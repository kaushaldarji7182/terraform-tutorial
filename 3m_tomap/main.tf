provider "aws" {
  region                  = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
}

variable "example_key_values" {
  type    = list(object({
    key   = string
    value = string
  }))
  default = [
    { key = "key1", value = "value1" },
    { key = "key2", value = "value2" },
    { key = "key3", value = "value3" },
  ]
}

output "key_value_map" {
  value = tomap({ for pair in var.example_key_values : pair.key => pair.value })
}