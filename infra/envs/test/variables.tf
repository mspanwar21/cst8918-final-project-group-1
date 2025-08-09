variable "location" {
  default = "canadacentral"
  type = string
}
variable "resource_group_name" {
  default = "cst8918-final-project-group-1"
  type = string
}
variable "env" {
  default = "test"
  type = string
}
variable "node_count" {
  default = 1
  type = number
}