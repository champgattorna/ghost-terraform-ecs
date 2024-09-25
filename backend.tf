terraform {
  backend "s3" {
    bucket         = "alasco-task-terraform-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "alasco-task-terraform-state-lock"
    encrypt        = true
  }
}
