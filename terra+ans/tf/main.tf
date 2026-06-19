provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] # Canonical
}

# Fetch the existing key pair (no creation attempt)
data "aws_key_pair" "existing" {
  key_name = "ansib_key2"
}

locals {
  instances = {
    instance1 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
    instance2 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
    instance3 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
    instance4 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.micro"
    }
  }
}

resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = data.aws_key_pair.existing.key_name   # use existing key
  associate_public_ip_address = true

  tags = {
    Name = each.key
  }
}
