variable "app_name" {
  default = "nuxt-app"
}

variable "github_repo" {
  description = "GitHub repository URL for your Nuxt.js app"
}

variable "github_branch" {
  default = "main"
}

variable "github_owner" {
  description = "GitHub repository owner"
}

variable "github_oauth_token" {
  description = "GitHub OAuth Token"
}

variable "ecs_cluster_name" {
  default = "nuxt-ecs-cluster"
}

variable "desired_count" {
  default = 1
}