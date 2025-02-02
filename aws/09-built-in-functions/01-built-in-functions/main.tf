#07-review 


variable "list1" {
  type    = list
  default = ["a", "b"]
}

variable "list2" {
  type    = list
  default = ["c", "d"]
}

output "combined_list" {
  value = concat(var.list1, var.list2)
  #concatinate 
}


variable "my_list" {
  type    = list
  default = ["apple", "banana", "cherry"]
}



output "selected_element" {
  value = element(var.my_list, 1) # Returns "banana"
  #returns specific element 
}


output "list_length" {
  value = length(var.my_list) # Returns 3
  #returns length 
}

variable "keys" {
  type    = list
  default = ["name", "age"]
}

variable "values" {
  type    = list
  default = ["Alice", 30]
}

output "output_map" {
  value = tomap({"a" = 1, "b" = 2})
  #crete a map  
}


variable "my_map" {
  type    = map(string)
  default = {"name" = "Alice", "age" = "30"}
}

output "value" {
  value = lookup(var.my_map, "name") # Returns "Alice"
    #get name field from map 

}

output "joined_string" {
  value = join(", ", var.my_list) # Returns "apple, banana, cherry"
}