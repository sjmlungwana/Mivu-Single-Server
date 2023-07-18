## Automating the Deployment of Mivu Server on AWS using Terraform

This Terraform configuration code will create a server in aws europe region in the eu-central-1a Avaliability Zone then install, run and enable the following packeges. It will also create an Elastic Public IP Address for the server.

. InfluxDB (version OSS - 1.8.x) + Chronograf
. Grafana (version OSS 9.5.3)
. Salt-Master (version 3006)
. Salt-Minion (version 3006)

#### In order to foolow up with this lab you need the following things.

1. AWS Account -> access keys
2. Terraform installed on your machine
3. AWS configure utility installed on your machine
4. Git installed on your machine