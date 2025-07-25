module "rgs" {
    source = "../../child/RG_Module"
    rgs = var.rgs
  
}



module "aks_module" {
    source = "../../child/AKS_Module"
    aks_rs = var.aks_rs
    depends_on = [ module.rgs ]
  
}

module "log_analystic" {
    source = "../../child/Log_Analytic_Workspace"
    log_analytic = var.log_analytic
    depends_on = [ module.rgs ]
    
  
}