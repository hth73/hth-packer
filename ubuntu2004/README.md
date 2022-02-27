# Ubuntu Server examples using Packer

<img src="https://img.shields.io/badge/-Ubuntu%2020.04-E95420?logo=ubuntu&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-Packer-02A8EF?logo=packer&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-Ansible-EE0000?logo=ansible&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-AWS%20EC2-232F3E?logo=amazon-aws&logoColor=white&style=flat" /> 

---

## Commandline 

```bash
packer validate ubuntu.json
packer build ubuntu.json
packer build -var 'aws_access_key=key' -var 'aws_secret_key=secret' ubuntu.json
packer build -var-file=variables.json ubuntu.json
```

```bash
aws ec2 create-key-pair --key-name <MyNewKey> --output text > MyNewKey.pem
aws ec2 run-instances --instance-type t2.micro --count 1 --key-name MyNewKey --image-id ami-0dcc21bcb3c1e0218 # --security-groups <SECURITY GROUP NAME>
aws ec2 describe-instances --instance-ids i-038e34ae21840e98e

aws ec2 stop-instances --instance-ids i-038e34ae21840e98e
aws ec2 start-instances --instance-ids i-038e34ae21840e98e
aws ec2 terminate-instances --instance-ids i-038e34ae21840e98e

aws ec2 delete-key-pair --key-name MyNewKey && rm -r MyNewKey.pem
```
