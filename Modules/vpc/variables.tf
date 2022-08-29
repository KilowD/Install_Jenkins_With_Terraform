locals {
  ingress_rules = [{
    port        = 8080
    description = "http proxy Access"
    },
    {
      port        = 22
      description = "ssh Access"
    }
  ]
}
