terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}



data "aws_eks_cluster" "cluster" {
  name = module.eks.aws_eks_cluster_eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.aws_eks_cluster_eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}


#provider "helm" {
#
#
#  kubernetes = {
#    host                   = module.eks.aws_eks_cluster_eks_cluster_endpoint
#    cluster_ca_certificate = base64decode(module.eks.aws_eks_cluster_eks_cluster_certificate_authority_data)
#
#    exec = {
#      api_version = "client.authentication.k8s.io/v1beta1"
#      args        = ["eks", "get-token", "--cluster-name", module.eks.aws_eks_cluster_eks_cluster_name]
#      command     = "aws"
#    }
#  }
#}