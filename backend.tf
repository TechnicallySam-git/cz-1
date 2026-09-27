terraform {
  backend "s3" {
    bucket       = "bkt-cs1-build"
    key          = "case-study-1/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}