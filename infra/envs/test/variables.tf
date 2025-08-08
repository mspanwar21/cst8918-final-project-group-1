variable "location" {
  default = "canadacentral"
}
variable "resource_group_name" {
  default = "cst8918-final-project-group-1"
}
variable "env" {
  default = "test"
}
variable "node_count" {
  default = 1
}
variable "weather_api_key" {
  description = "API key for the weather service"
  type        = string
  sensitive   = true
}