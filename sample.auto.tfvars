prefix                    = "llm"
create_vpc                = true
vpc_name                  = "llm-vpc"
region                    = "ap-southeast-1"
azs                       = ["ap-southeast-1a", "ap-southeast-1b"]
vpc_cidr_block            = "172.31.0.0/16"
vpc_private_subnets_cidrs = ["172.31.48.0/20", "172.31.64.0/20"]
vpc_private_subnets_names = ["private-48-1a", "private-64-1b"]
vpc_public_subnets_cidrs  = ["172.31.0.0/20", "172.31.16.0/20"]
vpc_public_subnets_names  = ["public-0-1a", "public-16-1b"]

llm_server = "ollama"
llm_ec2_configs = [
  # For Ollama
  {
    id             = "0001"
    llm_model      = "gemma2:9b"
    vllm_serve_cmd = ""
    instance_type  = "g5g.xlarge"
    ami_id         = ""
    ebs_volume_gb  = 200
    app_port       = 11434
  },
  {
    id             = "0002Qwen"
    llm_model      = "qwen2:7b"
    vllm_serve_cmd = ""
    instance_type  = "g5g.xlarge"
    ami_id         = ""
    ebs_volume_gb  = 200
    app_port       = 11434
  },
  # For VLLM
  # {
  #   id            = "0001"
  #   llm_model     = "Qwen/Qwen2.5-1.5B"
  #   instance_type = "g5g.xlarge"
  #   ami_id        = ""
  #   ebs_volume_gb = 50
  #   app_port      = 8000

  #   vllm_serve_cmd = "vllm serve Qwen/Qwen2.5-1.5B  --dtype half"
  # },
  # {
  #   id            = "0002"
  #   llm_model     = "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B"
  #   instance_type = "g4dn.xlarge"
  #   ami_id        = ""
  #   ebs_volume_gb = 50
  #   app_port      = 8000

  #   vllm_serve_cmd = "vllm serve deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B --dtype half"
  # },
]

create_api_gw                   = true
api_gw_disable_execute_endpoint = false
# api_gw_domain                   = "xx.xxxx.com"
# api_gw_domain_route53_zone      = "xxxxx"
# api_gw_domain_ssl_cert_arn      = "arn:aws:acm:ap-southeast-1:xxxx:certificate/xxxxx"
