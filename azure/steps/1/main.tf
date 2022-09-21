terraform {
  required_verson = ">=1.0.0"	#terraform cli version - change this to <1.0 and see the effect
  required_providers {
     azurerm = {
       source  = "hashicorp/azurerm"
       version = "<3.0.0"		# provider version
     }
  }
}