terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    bucket       = "terraform-state-myomin"
    key          = "eks-project1/terraform/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
