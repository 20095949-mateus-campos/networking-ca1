# Module Title:         Network Systems and Administration
# Module Code:          B9IS121
# Module Instructor:    Kingsley Ibomo
# Assessment Title:     Automated Container Deployment and Administration in the Cloud
# Assessment Number:    1
# Assessment Type:      Practical
# Assessment Weighting: 60%
# Assessment Due Date:  Sunday, 9 November 2025, 8:36 AM
# Student Name:         Mateus Fonseca Campos
# Student ID:           20095949
# Student Email:        20095949@mydbs.ie
# GitHub Repo:          TBA

# Defines Amazon Web Services (AWS) as the cloud infrastructure provider
provider "aws" {
  region = "eu-west-1" # physical location of the infrastructure is Ireland
}

# Generates private key for SSH connection
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Creates key pair for SSH connection
resource "aws_key_pair" "key_pair" {
  key_name   = "net_ca1_key"
  public_key = tls_private_key.private_key.public_key_openssh # extracts public key from previously generated private key
}

# Saves private key in local host
resource "local_sensitive_file" "local_private_key" {
  filename        = "${aws_key_pair.key_pair.key_name}.pem"     # saves as net_ca1_key.pem
  content         = tls_private_key.private_key.private_key_pem # file content is the private key
  file_permission = "0400"                                      # onwer can read, all else not allowed
}

# Creates security group (firewall configuration) to allow HTTP, HTTPS and SSH traffic
resource "aws_security_group" "allow_http_https_ssh" {
  name        = "allow_http_https_ssh"
  description = "Allow only HTTP, HTTPS and SSH traffic"
}

# Crates rule to allow all inbound HTTP traffic on port 80
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_http_ipv4" {
  security_group_id = aws_security_group.allow_http_https_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Crates rule to allow all inbound HTTPS traffic on port 443
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_https_ipv4" {
  security_group_id = aws_security_group.allow_http_https_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Uncomment the block below if your ISP does not reassign your IP address with every request, then swap the cidr_ipv4 values in the SSH ingress rule
# Creates a data variable to hold my public ip address
# data "http" "my_ip" {
#   url = "https://ifconfig.me/ip"
# }

# Crates rule to allow all inbound SSH traffic on port 22
resource "aws_vpc_security_group_ingress_rule" "allow_inbound_ssh" {
  security_group_id = aws_security_group.allow_http_https_ssh.id
  # cidr_ipv4         = "${data.http.my_ip.response_body}/32" # only accessible from my local host
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

# Creates rule to allow all outbound traffic on all ports
resource "aws_vpc_security_group_egress_rule" "allow_outbound_all" {
  security_group_id = aws_security_group.allow_http_https_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Creates EC2 instance (this is the web server)
resource "aws_instance" "net_ca1_server" {
  ami                    = "ami-0bc691261a82b32bc"                              # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type, 64-bit (x86)
  instance_type          = "t3a.small"                                          # 2 GiB of memory
  key_name               = aws_key_pair.key_pair.key_name                       # SSH key created previously
  vpc_security_group_ids = tolist([aws_security_group.allow_http_https_ssh.id]) # attach to security group
}

# Writes the public IP address of the newly created EC2 instance to the Ansible inventory
resource "null_resource" "update_ansible_inventory" {
  provisioner "local-exec" {
    command = "sed -i -e 's/ansible_host: .*/ansible_host: ${aws_instance.net_ca1_server.public_ip}/' ../ansible/inventory.yaml"
  }
}
