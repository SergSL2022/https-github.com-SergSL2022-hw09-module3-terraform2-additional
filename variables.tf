variable "name" {
  description = "name"
  type        = string
  default     = "slipchuk"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.16.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["172.16.101.0/24"]
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["172.16.1.0/24"]
}

variable "open_ports" {
    description = "List of open ports"
    type = list(number)
    default = [22, 80, 443]
}
