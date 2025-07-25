variable "log_analytic" {
  description = "Map of Log Analytics workspaces with their names and other optional settings"
  type = map(object({
    l_name = string
  }))
}