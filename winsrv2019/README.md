# Create Windows Server 2019 AMIs using Packer

<img src="https://img.shields.io/badge/-Windows%20Server%202019-5E5E5E?logo=windows&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-Packer-02A8EF?logo=packer&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-AWS%20IAM-232F3E?logo=amazon-aws&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-AWS%20S3-232F3E?logo=amazon-aws&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-AWS%20EC2-232F3E?logo=amazon-aws&logoColor=white&style=flat" /> 

---
## Prerequirements

To be able to work with the script cleanly, it needs a few preparations.
* S3 Bucket with two folders (winpkg and wincfg)
* iam-instance-profile

Why I use an S3 bucket? If you want to download software packages into the AMI image, it is much faster using an S3 bucket.

## Adjustments to the configuration files

## Script execution

```bash
packer build windows-server.pkr.hcl
```