variable "project" {
    type = string
}

variable "env" {
    type = string
}

variable "tags" {
    type = map
    default = {}
}

variable "vpc_cidr" {
    type = string
}

variable "public_subnet_cidrs" {
    type = list
}

variable "private_subnet_cidrs" {
    type = list
}

variable "db_subnet_cidrs" {
    type = list
}