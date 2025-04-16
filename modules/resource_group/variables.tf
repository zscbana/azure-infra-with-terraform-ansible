variable "locations" {
  type = list(object({
    name     = string
    location = string
  }))
  default = [
    { name = "HubWestEurope01rg", location = "West Europe" },
    { name = "france01RG",    location = "France Central" },
    { name = "eastUS01RG",    location = "East US" }
  ]
}
