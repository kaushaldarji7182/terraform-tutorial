resource_group_name = "aks_terraform_rg"
location            = "West Europe"
cluster_name        = "terraform-aks"
kubernetes_version  = "1.21.7"
#az aks get-versions --location westeurope --output table #version not supported error
system_node_count   = 3
acr_name            = "vilastthef001acr"