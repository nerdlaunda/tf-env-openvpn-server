output "Private-Key" {
  value     = module.key-pair.private_key_pem
  sensitive = true
}

output "Private-Key-OpenSSH" {
  value     = module.key-pair.private_key_openssh
  sensitive = true
}

output "ami" {
  value = data.aws_ami.Openvpn-AMI.image_id
}