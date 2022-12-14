variable "token" {
    default=""
}

variable "folder_id" {
    default=""
}

variable "cloud_id" {
    default=""
}

variable "zone" {
    default=""
}

variable "bucket" {
    default=""
}

variable "access_key" {
    default=""
}

variable "secret_key" {
    default=""
}

locals {
    instance_platform = {
        stage = "standard-v1"
        prod = "standard-v2"
    }
    instance_count = {
        stage = 1
        prod = 2
    }
    workscpace_instances = {
        prod = { 
            "first" = {platform = "standard-v2", cores = 4, memory = 4}
            "second" = {platform = "standard-v2", cores = 2, memory = 4}
        }
        stage = {
            "first" = {platform = "standard-v1", cores = 2, memory = 2}
        }
    }
    workspace_lans = {
        prod = ["192.168.10.0/24"]
        stage = ["192.168.11.0/24"]
    }
}
