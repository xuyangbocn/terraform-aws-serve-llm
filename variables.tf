variable "prefix" {
  description = "Prefix to resource created by this module"
  type        = string
  default     = "llm"
}

variable "region" {
  description = "AWS region for setup"
  type        = string
  default     = "ap-southeast-1"
}

variable "azs" {
  description = "Availability zones to deploy the EC2"
  type        = list(string)
}

variable "llm_server" {
  description = "Choose Ollama or VLLM as framework for deployment."
  type        = string
  validation {
    condition     = var.llm_server != "vllm" || var.llm_server != "ollama"
    error_message = "llm_server should be in [vllm, ollama]"
  }
}

variable "llm_ec2_configs" {
  description = "List of EC2/EBS config for each LLM EC2"
  /* Ex.
  [
    {
      id = "instance_x"
      llm_model = "llama3:8b"
      instance_type = "g5g.xlarge"
      ami_id = "" 
      ebs_volume_gb = 200
      app_port = 11434

      vllm_serve_cmd = "vllm serve deepseek-ai/DeepSeek-R1-Distill-Qwen-7B --dtype half --gpu-memory-utilization 0.9"
    },
  ]
  */
  type = list(object({
    id            = string # unique id to the instance
    llm_model     = string
    instance_type = string
    ami_id        = string # if empty string, fall back to default DL AMI by AWS
    ebs_volume_gb = number
    app_port      = number

    vllm_serve_cmd = string
  }))
}


# VPC related
variable "create_vpc" {
  description = "Whether to create a vpc or use an existing vpc"
  type        = bool
  default     = false
}

variable "vpc_cidr_block" {
  description = "CIDR block of VPC"
  type        = string
}

variable "vpc_id" {
  description = "(If create_vpc=false) VPC id to deploy the EC2"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "(If create_vpc=false) ID of subnets to deploy the EC2, recommend pvt subnets"
  type        = list(string)
  default     = []
}

variable "vpc_name" {
  description = "(If create_vpc=true) Name of vpc to be created"
  type        = string
  default     = "llm-vpc"
}

variable "vpc_private_subnets_names" {
  description = "(If create_vpc=true) List of VPC private subnets name"
  type        = list(string)
  default     = ["private-48-1a", "private-64-1b", "private-80-1c"]
}

variable "vpc_private_subnets_cidrs" {
  description = "(If create_vpc=true) List of VPC private subnets cidrs"
  type        = list(string)
  default     = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]
}

variable "vpc_public_subnets_names" {
  description = "(If create_vpc=true) List of VPC public subnets name"
  type        = list(string)
  default     = ["public-0-1a", "public-16-1b", "public-32-1c"]
}

variable "vpc_public_subnets_cidrs" {
  description = "(If create_vpc=true) List of VPC public subnets cidrs"
  type        = list(string)
  default     = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
}


# ALB Related
variable "additional_ingress_port" {
  description = "ALB security group will whitelist ingress traffic over this port from within VPC"
  type        = number
  default     = 0
}


# API GW Related
variable "create_api_gw" {
  description = "Whether to front and expose the internal ALB with API Gateway"
  type        = bool
  default     = true
}

variable "api_gw_disable_execute_endpoint" {
  description = "API Gateway not to expose its own execute endpoint"
  type        = bool
  default     = true
}

variable "api_gw_domain" {
  description = "Domain to be used for API Gw custom domain name setup"
  type        = string
  default     = ""
}

variable "api_gw_domain_route53_zone" {
  description = "Route53 zone id where the custom domain name is hosted at"
  type        = string
  default     = ""
}

variable "api_gw_domain_ssl_cert_arn" {
  description = "The arn of the acm cert for API Gw custom domain name setup"
  type        = string
  default     = ""
}
