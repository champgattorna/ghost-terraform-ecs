#          ██████   █████   ██████ ██   ██ ███████ ███    ██ ██████            
#          ██   ██ ██   ██ ██      ██  ██  ██      ████   ██ ██   ██           
#█████     ██████  ███████ ██      █████   █████   ██ ██  ██ ██   ██     █████ 
#          ██   ██ ██   ██ ██      ██  ██  ██      ██  ██ ██ ██   ██           
#          ██████  ██   ██  ██████ ██   ██ ███████ ██   ████ ██████            
                                                                              
# Written by Christian Hamp                                                   
# Datum: 24.09.2024                                                                                  

terraform {
  backend "s3" {
    bucket         = "ghost-task-terraform-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "ghost-task-terraform-state-lock"
    encrypt        = true
  }
}
