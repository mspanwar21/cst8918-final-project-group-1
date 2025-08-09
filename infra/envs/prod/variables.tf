variable "location" {
  default = "canadacentral"
}
variable "resource_group_name" {
  default = "cst8918-final-project-group-1"
}
variable "env" {
  default = "prod"
}
variable "node_count" {
  default = 2
}
variable "weather_api_key" {
  description = "API key for the weather service"
  type        = string
  sensitive   = true
}