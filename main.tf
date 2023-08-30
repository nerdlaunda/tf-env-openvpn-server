module "key-pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.2"

  key_name           = "VPN-Server-Key"
  create_private_key = true
}

resource "aws_vpc" "access-vpn" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "192.168.0.0/16"
  enable_dns_hostnames                 = false
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = {
    "Name" = "VPN-vpc"
  }
  tags_all = {
    "Name" = "VPN-vpc"
  }
}

resource "aws_subnet" "Public-Access-1a" {
  cidr_block                          = var.subnet_cidr
  private_dns_hostname_type_on_launch = "ip-name"
  tags = {
    "Name" = "Public-Access-1a"
  }
  tags_all = {
    "Name" = "Public-Access-1a"
  }
  vpc_id = aws_vpc.access-vpn.id
}

resource "aws_internet_gateway" "access-vpn-ig" {
  tags = {
    "Name" = "Public-Access-IG"
  }
  tags_all = {
    "Name" = "Public-Access-IG"
  }
  vpc_id = aws_vpc.access-vpn.id
}


resource "aws_route_table" "vpn_pulic_access_rt" {

  route {
    gateway_id = aws_internet_gateway.access-vpn-ig.id
    cidr_block = "0.0.0.0/0"
  }
  route {
    gateway_id = "local"
    cidr_block = aws_vpc.access-vpn.cidr_block
  }

  tags = {
    "Name" = "Public-Access-IG"
  }
  tags_all = {
    "Name" = "Public-Access-IG"
  }
  vpc_id = aws_vpc.access-vpn.id
}

resource "aws_route_table_association" "Public_subnet_assoc" {
  subnet_id      = aws_subnet.Public-Access-1a.id
  route_table_id = aws_route_table.vpn_pulic_access_rt.id
}

resource "aws_security_group" "vpn-instance-sg" {
  description = "OpenVPN Access Server-2.11.3-AutogenByAWSMP--1 created 2023-08-26T10:18:34.552Z"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 1194
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "udp"
      security_groups  = []
      self             = false
      to_port          = 1194
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 943
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 943
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 945
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 945
    },
  ]
  name     = "OpenVPN Access Server-2.11.3-AutogenByAWSMP--1"
  tags     = {}
  tags_all = {}
  vpc_id   = aws_vpc.access-vpn.id
}

resource "aws_instance" "VPN-Server-Instance" {
  ami                                  = var.ami == null ? data.aws_ami.Openvpn-AMI.image_id : var.ami
  associate_public_ip_address          = true
  availability_zone                    = aws_subnet.Public-Access-1a.availability_zone
  iam_instance_profile                 = var.iam_instance_profile
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = var.instance_type
  key_name                             = module.key-pair.key_pair_name
  subnet_id                            = aws_subnet.Public-Access-1a.id
  tags = {
    "Name" = "VPN-Server"
  }
  tags_all = {
    "Name" = "VPN-Server"
  }
  vpc_security_group_ids = [
    aws_security_group.vpn-instance-sg.id,
  ]

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    tags                  = {}
    volume_size           = 8
    volume_type           = "gp2"
  }
}
