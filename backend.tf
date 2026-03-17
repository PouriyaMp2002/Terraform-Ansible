terraform {
  backend "s3" {
    bucket = "terraform3392" // This bucket should be created. 
    key    = "terraform"
    region = "us-east-1"
  }
}
