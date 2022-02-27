# ---------------------------------------------------------------------------------------------------------------------
# Create an AWS Custom Ubuntu Server 20.04 AMI
# ---------------------------------------------------------------------------------------------------------------------
variable "aws_access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY")}"
}

variable "aws_secret_key" {
  type    = string
  default = "${env("AWS_SECRET_KEY")}"
}

data "amazon-ami" "ubuntu-srv" {
  access_key = "${var.aws_access_key}"
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  secret_key  = "${var.aws_secret_key}"
}

locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
}

source "amazon-ebs" "ubuntu-srv" {
  access_key    = "${var.aws_access_key}"
  secret_key    = "${var.aws_secret_key}"
  ssh_username  = "ubuntu"
  ami_name      = "packer-ubuntu-${local.timestamp}"
  instance_type = "t2.micro"
  source_ami    = "${data.amazon-ami.ubuntu-srv.id}"
}

build {
  sources = ["source.amazon-ebs.ubuntu-srv"]

  provisioner "file" {
    source      = "files/website"
    destination = "~/website"
  }

  provisioner "shell" {
    inline = [
      "sudo apt update", 
      "sudo apt install -y nginx", 
      "sudo mv ~/website/* /var/www/html/", 
      "sudo systemctl restart nginx", 
      "sudo systemctl enable nginx", 
      "sudo ufw allow 80"
    ]
  }
}
