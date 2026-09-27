provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project = "Case Study 1"
    }
  }
}
