variable "location" {

}
variable "project_name" {

}

variable "environment" {

}

variable "cidr_block" {

}

variable "enable_dns_hostnames" {
  default = true
}

variable "commn_tags" {

}

variable "vpc_tags" {
  default = {}
}

variable "igw_tags" {
    default = {}
}

variable "public_subnet_cidr" {
    type = list 
    validation {
        condition = length(var.public_subnet_cidr) == 2
        error_message = "You should provide 2 valid pulic subnet CIDR"
    }
}

variable "public_subet_tags" {
    default = {}
}

variable "private_subnet_cidr" {
    type = list
    validation {
        condition = length(var.private_subnet_cidr) == 2
        error_message = "You should provide 2 valid private subnet CIDR"
    }
}

variable "private_subnet_tags" {
    default = {}
}

variable "database_subnet_cidr" {
    type = list
    validation {
        condition = length(var.database_subnet_cidr) == 2
        error_message  = "You should provide 2 valid database subnet CIDR"
    }
}

variable "database_subnet_tags" {
    default = {}
}

variable "nat_gateway_tags" {
    default = {}
}
