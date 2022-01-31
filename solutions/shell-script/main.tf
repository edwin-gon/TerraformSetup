module "remote_state" {
  source = "../modules/RemoteState"

  naming_prefix = "sh-config"
  bucket_name   = "tf-bucket"
  table_name    = "tf-lock-table"
  region        = "us-east-1"
}
