variable "naming_prefix" {
  type        = string
  description = "Prefix used when naming resources"
}
variable "bucket_name" {
  type        = string
  description = "Name of the remote state bucket"
}

variable "table_name" {
  type        = string
  description = "Name of lock table"
}

variable "region" {
  type        = string
  description = "Region where resources to be deployed"
}

variable "custom_tags" {
  type        = map(string)
  description = "Custom Tags to be used"
  default     = {}

}
