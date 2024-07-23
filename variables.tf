#default global tags
variable "region" {
    type        = string
    description = "regions where resources will be created"
}

variable "project_name" {
    type        = string
    description = "name of the project"
}

variable "environment" {
    type        = string
    description = "environment of the project"
}

variable "vpc_cidr" {
    type = string
    description = "cidr for vpc"
}

variable "vpc_public_subnet_az1_cidr" {
    type = string
    description = "cidr for public subnet az1"
}

variable "vpc_private_data_subnet_az1_cidr" {
    type = string
    description = "cidr for private data subnet az1"
}

variable "vpc_private_data_subnet_az2_cidr" {
    type = string
    description = "cidr for private data subnet az2"
}
