variable "aws_region" {
  description = "Default AWS region."
  default     = "us-east-1"
}
variable "bucket" {
    type="string"
    default="terraform-state"
}

variable "table" {
    type="string"
    default="terraform-state-lock"
}

variable "organization" {
    type="string"
}

variable "prefix" {
    type="string"
}
