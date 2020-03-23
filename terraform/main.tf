terraform {
  backend "local" {}
}

provider "aws" {
  version = "~> 2.54.0"
  region  = "eu-west-2"
}

module "dev" {
  source = "./app"

  environment_prefix = "dev-"
}