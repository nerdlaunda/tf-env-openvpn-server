data "aws_ami" "Openvpn-AMI" {
  most_recent = true
  #   name_regex       = "^myami-\\d{3}"

  filter {
    name   = "name"
    values = ["OpenVPN Access Server QA Image-fe8020db-5343-4c43-9e65-5ed4a825c931"]
  }
}