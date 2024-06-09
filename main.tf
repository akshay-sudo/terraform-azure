#Terraform block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

#Provider block
provider "aws" {
  region     = var.awsRegion
  access_key = var.accessKey
  secret_key = var.secretKey
}


variable "awsRegion" {}

variable "accessKey" {}

variable "secretKey" {}

variable "stackName" {
  type= string
}
/*
variable "bucketName" {
    type = string  
}

variable "accessControl" {
  type = string
}

variable "bucketEncryption" {
  type = string
}
*/
resource "aws_cloudformation_stack" "passwd-policy" {
  name = var.stackName
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    #BucketName = var.bucketName
    #AccessControl = var.accessControl
    #BucketEncryption = var.bucketEncryption
    PermissionsBoundary = " "
    MinimumPasswordLength = 6
    RequireUppercaseCharacters = true
    RequireLowercaseCharacters = true
    RequireNumbers = true
    RequireSymbols = true
    MaxPasswordAge = 90
    PasswordReusePrevention = 24
    AllowUsersToChangePassword = true
    HardExpiry = false
    LogsRetentionInDays = 90
    
  }

  template_body = file("${path.module}/password-policy.yaml")
}


##
#awsRegion= "us-east-1"
#
#Key= "eFU3G4Rx9JtWQdCXxe6cxZjfpoxxp8QflhywiTz8"

#stackName= "CEdeltaCFT2TFManTest01"
