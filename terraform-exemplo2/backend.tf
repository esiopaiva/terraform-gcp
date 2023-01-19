terraform {
 backend "gcs" {
   bucket  = "terraformdesyncesio"
   prefix  = "terraform/state"
 }
}