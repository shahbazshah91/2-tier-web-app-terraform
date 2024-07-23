provider "aws" {
  region  = var.region
  profile = "terraform-user"
  
  #tags to be applied on every resource
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
    }
  }
}