variable "region_name" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.10.0.0/16"
}

variable "environment" {
  type    = string
  default = "development"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.10.0.0/24", "10.10.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.3.0/24"]
}

variable "public_az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "private_az" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    port        = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    { port = 22, protocol = "tcp", cidr_block = "0.0.0.0/0", description = "SSH access" },
    { port = 80, protocol = "tcp", cidr_block = "0.0.0.0/0", description = "HTTP access" }
  ]
}

variable "sg_egress_rules" {
  description = "Egress rules for the security group"
  type = list(object({
    port        = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    { port = 0, protocol = "-1", cidr_block = "0.0.0.0/0", description = "Allow all outbound" }
  ]
}

variable "create_internet_gateway" {
  description = "Create Internet Gateway for public subnets"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Create NAT Gateway for private subnets"
  type        = bool
  default     = true
}
