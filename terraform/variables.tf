variable github_token {
  type        = string
  default     = ""
}

variable aws_region {
  type        = string
  default     = "us-east-1"
}

variable "availability_zone1" {
    type = string
    default = "us-east-1a"
}

variable "availability_zone2" {
    type = string
    default = "us-east-1b"
}

variable "aws_route53_zone_id"{
    type = string
}

variable "aws_route53_record_name"{
    type = string
}

variable "aws_acm_certificate_arn" {
    type = string
}

variable "app_name" {
    type = string
}

variable "github_owner" {
    type = string
}

variable "github_repo" {
    type = string
}

variable "github_branch" {
    type = string
}

variable "app_port" {
    type = number
}