locals {
  vpc_id     = var.create_vpc ? one(module.vpc[*].vpc_id) : var.vpc_id
  subnet_ids = var.create_vpc ? one(module.vpc[*].private_subnets) : var.subnet_ids

  ami_id = {
    "g5g" : data.aws_ami.dlami_arm.id,
    "g4dn" : data.aws_ami.dlami_x86.id,
    "g5" : data.aws_ami.dlami_x86.id,
  }

  ec2_iamr_policies = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ]

  user_data = <<-EOF
    #!/bin/bash
    # Enable GPU monitoring
    sudo systemctl enable dlami-cloudwatch-agent@partial
    sudo systemctl start dlami-cloudwatch-agent@partial

    EOF

  ec2_configs = {
    for i, v in var.llm_ec2_configs :
    replace(v.id, "/[-_.:/]/", "") => {
      id                          = replace(v.id, "/[-_.:/]/", "")
      llm_model                   = v.llm_model
      instance_family             = split(".", v.instance_type)[0]
      instance_type               = v.instance_type
      ami                         = v.ami_id == "" ? local.ami_id[split(".", v.instance_type)[0]] : v.ami_id
      ebs_volume_gb               = v.ebs_volume_gb
      subnet_id                   = element(local.subnet_ids, i)
      az                          = element(var.azs, i)
      app_port                    = v.app_port
      user_data                   = local.user_data
      user_data_replace_on_change = false

      ollama_main_ec2    = (var.llm_server == "ollama" && i == 0) ? true : false
      ollama_pull_models = (var.llm_server == "ollama" && i == 0) ? [for each in var.llm_ec2_configs : each.llm_model] : [v.llm_model]
      vllm_serve_cmd     = v.vllm_serve_cmd

      listener_rule_priority = i + 1
    }
  }

  apigw_configs = {
    create_custom_domain = tobool(
      var.create_api_gw &&
      var.api_gw_domain != "" &&
      var.api_gw_domain_route53_zone != "" &&
      var.api_gw_domain_ssl_cert_arn != ""
    )
    disable_execute_endpoint = tobool(
      var.api_gw_domain != "" &&
      var.api_gw_domain_route53_zone != "" &&
      var.api_gw_domain_ssl_cert_arn != ""
    ) ? var.api_gw_disable_execute_endpoint : false
  }

  # tags
  tags = {
    "system" = var.prefix
  }
}
