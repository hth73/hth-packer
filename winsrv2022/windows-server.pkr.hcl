# ---------------------------------------------------------------------------------------------------------------------
# Create an AWS Custom Windows Server 2022 AMI
# ---------------------------------------------------------------------------------------------------------------------
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
      name = "Windows_Server-2022-English-Full-Base-*"
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners = ["801119661308"]
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

  provisioner "file" {
    source = "files/agent-config.yml"
    destination = "C:\\ProgramData\\Amazon\\EC2Launch\\config\\agent-config.yml"
  }

  provisioner "file" {
    source = "files/img1.jpg"
    destination = "C:\\Windows\\Web\\Wallpaper\\Windows\\img1.jpg"
  }

  provisioner "powershell" {
    script = "scripts/inst_winpkg.ps1"
  }

  # provisioner "file" {
  #  source = "s3scripts/config_server.ps1"
  #  destination = "C:\\tools\\config_server.ps1"
  # }

  provisioner "powershell" {
    inline = [
      # Server Basic Configuration
      # "C:\\tools\\config_server.ps1"
      "C:\\tools\\wincfg\\config_server.ps1"
    ]
  }

  provisioner "windows-shell" {
    inline = [
      # Remove system specific information from this image with sysprep
      "cd %ProgramFiles%\\Amazon\\EC2Launch\\",
      "EC2Launch.exe sysprep --block --clean --shutdown"
    ]
  }
}
