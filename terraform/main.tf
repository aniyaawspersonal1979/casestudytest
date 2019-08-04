provider "aws" {
        access_key = "XXXXXXX"
        secret_key = "XXXXXXXXXMEe"
        region = "us-east-2"
}


# Creating the Security Group !!

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Creating ec2 instance with
resource "aws_instance" "casestudy" {
        ami = "ami-02f706d959cedf892"
        instance_type = "t2.micro"
        tags = { Name: "casestudy",
		 Role = "app"
		}
        key_name = "shaan-rewind"
        availability_zone = "us-east-2a"
        security_groups = ["${aws_security_group.allow_all.name}"]
        root_block_device {
                volume_size = 20
        }
}

# Attaching 100GB volume to the Ec2 instance

resource "aws_volume_attachment" "tasc-volume" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.tasc-ebs.id
  instance_id = "${aws_instance.casestudy.id}"
}

# Creating the ebs volume with 100GB size

resource "aws_ebs_volume" "tasc-ebs" {
  availability_zone = "us-east-2a"
  size              = 100
  tags = {
    Name = "Ebs-Volume"
  }
}

