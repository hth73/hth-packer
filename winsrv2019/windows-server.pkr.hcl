## Create an AWS Custom Windows Server 2019 AMI
##
variable "profile" {
  type = string
  default = "win-srv"
}

variable "ami_name" {
  type = string
  default = "win-srv-{{timestamp}}"
}

variable "instance_type" {
  type = string
  default = "t3a.medium"
}

variable "name" {
  type = string
  default = "tst-win-srv"
}

source "amazon-ebs" "windows" {

  region = "eu-west-1"
  iam_instance_profile = "IAM INSTANCE PROFILE NAME"

  ami_name = "${var.ami_name}"
  instance_type = "${var.instance_type}"
  source_ami_filter {
    filters = {
      name = "Windows_Server-2019-English-Full-Base-*"
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners = ["amazon"]
  }

  communicator = "winrm"
  winrm_username = "Administrator"
  winrm_use_ssl = true
  winrm_insecure = true

  # This user data file sets up winrm and configures it so that the connection
  # from Packer is allowed. Without this file being set, Packer will not
  # connect to the instance.
  user_data_file = "scripts/winrm_bootstrap.txt"

  tags = {
    Name = "${var.name}",
    AMI-Group = "${var.profile}"
  }

  run_tags = {
    Name = "Packer Builder ${var.profile}"
  }
}

build {
  sources = ["source.amazon-ebs.windows"]

  provisioner "powershell" {
    script = "scripts/inst_winpkg.ps1"
  }

  provisioner "powershell" {
    inline = [
      # Re-initialise the AWS instance on startup
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/InitializeInstance.ps1 -Schedule",
      # Remove system specific information from this image
      "C:/ProgramData/Amazon/EC2-Windows/Launch/Scripts/SysprepInstance.ps1 -NoShutdown"
    ]
  }
}
