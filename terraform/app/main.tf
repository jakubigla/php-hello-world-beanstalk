variable "environment_prefix" {
  type = string
}

locals {
  application_name    = "${var.environment_prefix}df-restless-poc"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.3 running PHP 7.3"
}

resource "aws_elastic_beanstalk_application" "current" {
  name        = local.application_name
  description = local.application_name
}

resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "${var.environment_prefix}blue"
  application         = aws_elastic_beanstalk_application.current.name
  solution_stack_name = local.solution_stack_name

  cname_prefix        = "staging-${local.application_name}"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }

  tags = {
    CurrentColor = "blue"
  }

  lifecycle {
    ignore_changes = [tags,name]
  }
}

resource "aws_elastic_beanstalk_environment" "green" {
  name                = "${var.environment_prefix}green"
  application         = aws_elastic_beanstalk_application.current.name
  solution_stack_name = local.solution_stack_name

  cname_prefix        = "live-${local.application_name}"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }

  tags = {
    CurrentColor = "green"
  }

  lifecycle {
    ignore_changes = [tags,name]
  }
}