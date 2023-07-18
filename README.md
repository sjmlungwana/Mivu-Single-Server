## Automating the Deployment of Mivu Server on AWS using Terraform

This Terraform configuration code will create a server in aws europe region in the eu-central-1a Avaliability Zone then install, run and enable the following packeges. It will also create an Elastic Public IP Address for the server.

1. InfluxDB (version OSS - 1.8.x) + Chronograf
2. Grafana (version OSS 9.5.3)
3. Salt-Master (version 3006)
4. Salt-Minion (version 3006)

#### In order to follow up with this lab you need the following things.

1. AWS Account -> access keys
2. Terraform installed on your machine
3. AWS configure utility installed on your machine
4. Git installed on your machine

### AWS Account -> Access Keys

login to your AWS account, search IAM, select users, select your username, select security credentials, create Access Keys, download the csv file and copy your keys.

### Terraform Installation

run these command
1. wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
2. echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
3. sudo apt update && sudo apt install terraform

https://developer.hashicorp.com/terraform/downloads?product_intent=terraform

### AWS configure utility installation

run these commands
1. sudo apt-get update
2. sudo apt-get install awscli
3. aws --version

#### Now you need to add your access keys to your machine.

You need to use those keys you created from AWS console

run this command

1. aws configure
AWS Access Key ID [None]: ACCESS KEYS
AWS Secret Access Key [None]: SECRETE ACCESS KETS
Default region name [None]: [leave this one]
Default output format [None]: json

#### ______ Running Terraform Configuration Code _______

First clone this repo to your local machine

git clone https://github.com/sjmlungwana/Mivu-Single-Server.git

cd Mivu-Single-Server

terraform init

terraform plan

terraform apply -auto-approve