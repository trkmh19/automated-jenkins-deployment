# Project Name

**Automated Jenkins Deployment in Docker on Azure using Terraform and Ansible**

# Description

This project provides an automated and reproducible solution for deploying Jenkins in a Docker container on Microsoft Azure Cloud infrastructure.

# Table of Contents

- [Project Name](#project-name)
- [Description](#description)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [How to Use](#how-to-use)
  - [Terraform](#terraform)
  - [Ansible](#ansible)
  - [Accessing Jenkins](#accessing-jenkins)
- [Contribution](#contribution)

# Prerequisites

- Sign up for a free Azure account if you don't have one [Azure Account](https://azure.microsoft.com/en-us/free/) .
- Install Terraform from the official website [Terraform](https://www.terraform.io/downloads.html) .
- Install Ansible from the official website [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) .

- Generate SSH keypairs that will be used for authentication with the virtual machines.


- Follow the steps outlined in the [Azure Provider: Authenticating using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli) to set up login using Azure CLI for terraform Azure provider.

# How to Use

1. Clone this repository: `git clone https://github.com/trkmh19/automated-jenkins-deployment.git`
2. Change into the repository directory: `cd automated-jenkins-deployment`

## Terraform

- Modify variables in the Terraform configuration file `terraform/terraform.tfvars`:
  - `resource_group_name`
  - `location`
  - `admin_username`
  - `public_key_path` (path to the public key generated earlier)
- Initialize Terraform: `terraform init`
- Plan the infrastructure changes: `terraform plan --out jenkins.tfplan`
- Apply the changes to create the Azure resources: `terraform apply jenkins.tfplan`
- Note the IP address of the VM provided as the output.

## Ansible

- Modify variables in the Ansible configuration files:
  - `IP address of the VM` ( in the fil `ansible/inventories/jenkins/hosts` )
  - `username of the VM` (in the file `ansible/inventories/jenkins/group_vars/jenkins.yml`)
- Run the Ansible playbook: `ansible-playbook site.yml -i inventories/jenkins`

## Accessing Jenkins

- After Ansible finishes, you can access Jenkins on the browser : `<VM IP Address>:8080`.
- To complete the setup, SSH to the VM and retrieve the initial admin password from the logs of the container: `docker logs jenkins-dood`.
- Paste the initial admin password in the Jenkins web interface.
- Create a new user and start using Jenkins.

# Contribution

We welcome contributions to this project! To contribute, follow these steps:

1. Fork the repository.
2. Create a new branch for your feature/fix: `git checkout -b your-feature-branch`.
3. Make your changes and commit them: `git commit -m "Add your message here"`.
4. Push your changes to your fork: `git push origin your-feature-branch`.
5. Open a pull request against the main repository.
