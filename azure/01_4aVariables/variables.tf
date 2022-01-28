variable "resource_group_name" {
  default = "myTFResourceGroup"
  
  #type: the type of the variable.  others can access like var.resource_group_name.type
  #description: description of the variable. others can access like var.resource_group_name.description
  #default default value. others can access like var.resource_group_name
  #This content could be inside the same .tf file.
  #If you skip default value in the variable, you may be forced to enter while execture the terraform apply
}