# Our Cloud Provider Will be AWS
provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zone" "available" {
  name = "eu-central-1a"
}

data "aws_region" "current" {}

locals {
  team        = "DevOps"
  environment = "Dev"
  Terraform = "True"
}

#Define the VPC
resource "aws_vpc" "MiVu_VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name        = "MiVu VPC"
    Environment = "Test ENV"
    Terraform   = "True"
    Region      = data.aws_region.current.name
  }
}

#Deploy the private subnets
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.MiVu_VPC.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zone.available.name
  tags = {
    Name      = "Private Subnet"
    Terraform = "True"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.MiVu_VPC.id
  tags = {
    Name      = "MiVu IGW"
    Terraform = "True"
  }
}

#Create route tables for public and private subnets 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.MiVu_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
    #nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name      = "Public RT"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "route_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}
resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = "MyAWSKey.pem"
}
resource "aws_key_pair" "generated" {
  key_name   = "MyAWSKey"
  public_key = tls_private_key.generated.public_key_openssh
  lifecycle {
    ignore_changes = [key_name]
  }
  tags = {
    Name = "Main Key-Pair"
    Terraform = "True"
  }
}

# Security Groups
resource "aws_security_group" "ingress-ssh" {
  name   = "Main SG"
  vpc_id = aws_vpc.MiVu_VPC.id
  ingress {
    description = "SSH"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    description = "InfluxDB"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8086
    to_port   = 8086
    protocol  = "tcp"
  }

  ingress {
    description = "Chronograf"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8888
    to_port   = 8888
    protocol  = "tcp"
  }

  ingress {
    description = "Grafana"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
  }

  ingress {
    description = "custom tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 4505
    to_port   = 4506
    protocol  = "tcp"
  }

  ingress {
    description = "custom tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"
  }

  ingress {
    description = "custom tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 1194
    to_port   = 1194
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.MiVu_VPC.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8086
    to_port    = 8086
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8888
    to_port    = 8888
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3000
    to_port    = 3000
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 600
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 4505
    to_port    = 4506
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 700
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 9090
    to_port    = 9090
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 800
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1194
    to_port    = 1194
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8086
    to_port    = 8086
  }

  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8888
    to_port    = 8888
  }

  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 3000
    to_port    = 3000
  }

  egress {
    protocol   = "tcp"
    rule_no    = 600
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 4505
    to_port    = 4506
  }

  egress {
    protocol   = "tcp"
    rule_no    = 700
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 9090
    to_port    = 9090
  }

  egress {
    protocol   = "tcp"
    rule_no    = 800
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1194
    to_port    = 1194
  }

  tags = {
    Name = "Main NACL"
    Terraform = "True"
  }
}

resource "aws_network_acl_association" "main_acl" {
  network_acl_id = aws_network_acl.network_acl.id
  subnet_id      = aws_subnet.private_subnet.id
}

resource "aws_instance" "mivu_server" {
  ami                         = "ami-0b0c5a84b89c4bf99"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet.id
  security_groups             = [aws_security_group.ingress-ssh.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.generated.key_name
  connection {
    type        = "ssh"
    user        = "admin"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }

  # Leave the first part of the block unchanged and create our `local-exec` provisioner

  provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key_pem.filename}"
  }

  provisioner "remote-exec" {
    inline = [
      "wget https://dl.influxdata.com/influxdb/releases/influxdb_1.8.10_amd64.deb",
      "sudo dpkg -i influxdb_1.8.10_amd64.deb",
      "sudo systemctl enable influxdb.service",
      "sudo systemctl start influxdb.service",
      "wget https://dl.influxdata.com/chronograf/releases/chronograf_1.10.1_amd64.deb",
      "sudo dpkg -i chronograf_1.10.1_amd64.deb",
      "sudo systemctl enable chronograf.service",
      "sudo systemctl start chronograf.service",
      "sudo apt update",
      "sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/debian/11/amd64/latest/salt-archive-keyring.gpg",
      "sudo echo 'deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/debian/11/amd64/latest bullseye main' | tee /etc/apt/sources.list.d/salt.list",
      "sudo apt-get update -y",
      "sudo apt-get install python3 salt-common -y",
      "sudo apt-get install salt-master -y",
      "sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/debian/11/amd64/latest/salt-archive-keyring.gpg",
      "sudo echo 'deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/debian/11/amd64/latest bullseye main' | tee /etc/apt/sources.list.d/salt.list",
      "sudo apt-get update -y",
      "sudo apt-get install salt-minion -y",
      "sudo curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg https://repo.saltproject.io/py3/debian/11/amd64/latest/salt-archive-keyring.gpg",
      "sudo echo 'deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg arch=amd64] https://repo.saltproject.io/py3/debian/11/amd64/latest bullseye main' | tee /etc/apt/sources.list.d/salt.list",
      "sudo apt-get update -y",
      "sudo apt-get install salt-minion -y",
      "sudo apt update",
      "sudo apt-get install -y adduser libfontconfig1",
      "sudo wget https://dl.grafana.com/oss/release/grafana_9.5.3_amd64.deb",
      "sudo dpkg -i grafana_9.5.3_amd64.deb",
      "sudo systemctl enable grafana-server.service",
      "sudo systemctl start grafana-server.service",
    ]
  }

  tags = {
    Name      = "Mivu Server ${local.team}"
    Terraform = "True"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }
}
resource "aws_eip" "server_eip" {
  instance = aws_instance.mivu_server.id
  #vpc      = true
  tags = {
    Name = "Mivu Server EIP"
    Terraform = "True"
  }
}