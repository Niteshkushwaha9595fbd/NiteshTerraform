module "rgs" {
    source = "../../child/RG_Module"
    rgs = var.rgs
  
}

module "aks" {
    source = "../../child/AKS"
    Aks = var.Aks
    depends_on = [ module.rgs ]
  
}