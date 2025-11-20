# AWS VPC Terraform Module

This Terraform module provisions a **customizable VPC** with public and private subnets, Internet Gateway, NAT Gateway, route tables, and a default security group. It is designed to support **EKS or other AWS workloads**, with **dynamic IGW/NAT creation** and **variable-driven network configuration**.

---

## Features

- Custom VPC with **variable CIDR block**
- Public and private subnets across multiple **availability zones**
- **Internet Gateway** (optional) for public subnets
- **NAT Gateway** (optional) for private subnets
- Public and private **route tables** and associations
- Default **security group** with customizable ingress and egress rules
- Fully **variable-driven** for quick customization

---

## Architecture Diagram

```
                  +-----------------------------+
                  |          VPC                |
                  |       10.10.0.0/16         |
                  +-----------------------------+
                            |
       +----------------------------------------------+
       |                                              |
+-------------------+                        +-------------------+
|  Public Subnet 1  |                        |  Public Subnet 2  |
|  10.10.0.0/24     |                        |  10.10.2.0/24     |
+-------------------+                        +-------------------+
        |                                          |
        |                                          |
+-------------------+                        +-------------------+
|  IGW (Optional)   |                        |  NAT Gateway      |
+-------------------+                        |  (Optional)       |
                                             +-------------------+
                                                      |
                                                      |
        +-------------------+                +-------------------+
        |  Private Subnet 1 |                |  Private Subnet 2 |
        |  10.10.1.0/24     |                |  10.10.3.0/24     |
        +-------------------+                +-------------------+
```

- **IGW (Internet Gateway)** connects **public subnets** to the internet  
- **NAT Gateway** allows **private subnets** to access the internet without exposing them  
- **Route Tables** are automatically associated to public and private subnets

---

## Usage

1. Clone the repository:

```bash
git clone <repo-url>
cd <repo-folder>
```

2. Initialize Terraform:

```bash
terraform init
```

3. Plan the deployment:

```bash
terraform plan -var-file="terraform.tfvars"
```

4. Apply the deployment:

```bash
terraform apply -var-file="terraform.tfvars"
```

5. Destroy resources when done:

```bash
terraform destroy -var-file="terraform.tfvars"
```

---

## Variables

| Variable | Description | Type | Default |  
|----------|-------------|------|---------|  
| `region_name` | AWS region to deploy resources | string | `"us-east-1"` |  
| `environment` | Deployment environment name | string | `"development"` |  
| `vpc_cidr_block` | CIDR block for the VPC | string | `"10.10.0.0/16"` |  
| `public_subnets` | List of CIDR blocks for public subnets | list(string) | `["10.10.0.0/24","10.10.2.0/24"]` |  
| `private_subnets` | List of CIDR blocks for private subnets | list(string) | `["10.10.1.0/24","10.10.3.0/24"]` |  
| `public_az` | List of availability zones for public subnets | list(string) | `["us-east-1a","us-east-1b"]` |  
| `private_az` | List of availability zones for private subnets | list(string) | `["us-east-1a","us-east-1b"]` |  
| `create_internet_gateway` | Whether to create IGW for public subnets | bool | `true` |  
| `create_nat_gateway` | Whether to create NAT Gateway for private subnets | bool | `true` |  
| `sg_ingress_rules` | List of ingress rules for default security group | list(object) | `[ { port=22, protocol="tcp", cidr_block="0.0.0.0/0", description="SSH" }, { port=80, protocol="tcp", cidr_block="0.0.0.0/0", description="HTTP" } ]` |  
| `sg_egress_rules` | List of egress rules for default security group | list(object) | `[ { port=0, protocol="-1", cidr_block="0.0.0.0/0", description="All outbound" } ]` |  

---

## Notes

- **Subnets must be inside the VPC CIDR**  
- **NAT Gateway requires a public subnet and Elastic IP**  
- Security group rules are fully **variable-driven**  
- IGW and NAT Gateway are optional based on **variables**  

---

## Example `terraform.tfvars`

```hcl
region_name = "us-east-1"
environment = "dev"

vpc_cidr_block = "10.10.0.0/16"
public_subnets  = ["10.10.0.0/24", "10.10.2.0/24"]
private_subnets = ["10.10.1.0/24", "10.10.3.0/24"]

public_az  = ["us-east-1a","us-east-1b"]
private_az = ["us-east-1a","us-east-1b"]

create_internet_gateway = true
create_nat_gateway      = true

sg_ingress_rules = [
  { port=22, protocol="tcp", cidr_block="0.0.0.0/0", description="SSH access" },
  { port=80, protocol="tcp", cidr_block="0.0.0.0/0", description="HTTP access" }
]

sg_egress_rules = [
  { port=0, protocol="-1", cidr_block="0.0.0.0/0", description="All outbound traffic" }
]
```

