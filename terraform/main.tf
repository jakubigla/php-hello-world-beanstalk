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

module "prod" {
  source = "./app"

  environment_prefix = "prod-"
}

module "uat" {
  source = "./app"

  environment_prefix = "uat-"
}