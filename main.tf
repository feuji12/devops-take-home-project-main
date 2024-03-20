module "base_label" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "ll"
}

module "vpc_resources" {
  source = "./vpc"
  vpc_cidr = "192.170.0.0/20"
}  
