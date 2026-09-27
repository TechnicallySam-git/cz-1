# Copy this block into backend.tf after creating the state bucket.
# Do not put credentials in this file.

terraform {
  backend "s3" {
    bucket       = "bkt-cs1-build"
    key          = "case-study-1/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}