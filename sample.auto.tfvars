# region = "us-east-1"
# azs    = ["us-east-1a", "us-east-1b"]
create_vpc                = true
region                    = "ap-southeast-1"
azs                       = ["ap-southeast-1a", "ap-southeast-1b"]
vpc_private_subnets_cidrs = ["172.31.48.0/20", "172.31.64.0/20"]
vpc_private_subnets_names = ["private-48-1a", "private-64-1b"]
vpc_public_subnets_cidrs  = ["172.31.0.0/20", "172.31.16.0/20"]
vpc_public_subnets_names  = ["public-0-1a", "public-16-1b"]

llm_ec2_configs = [
  {
    server         = "ollama"
    llm_model      = "gemma2:9b"
    vllm_serve_cmd = ""
    instance_type  = "g5g.xlarge"
    ami_id         = ""
    ebs_volume_gb  = 200
    app_port       = 11434
  },
  {
    server         = "ollama"
    llm_model      = "qwen2:7b"
    vllm_serve_cmd = ""
    instance_type  = "g5g.xlarge"
    ami_id         = ""
    ebs_volume_gb  = 200
    app_port       = 11434
  },
  # {
  #   llm_model     = "llama3.1:8b"
  #   server = "ollama"
  #   vllm_serve_cmd = ""
  #   instance_type = "g5g.xlarge"
  #   ami_id        = ""
  #   ebs_volume_gb = 200
  #   app_port      = 11434
  # },
]

create_api_gw                   = true
api_gw_disable_execute_endpoint = true
# api_gw_domain                   = "xx.xxxx.com"
# api_gw_domain_route53_zone      = "xxxxx"
# api_gw_domain_ssl_cert_arn      = "arn:aws:acm:ap-southeast-1:xxxx:certificate/xxxxx"
