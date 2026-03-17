# Infrastructure Automation with Terraform & Ansible

This project demonstrates how to provision and configure AWS infrastructure using **Terraform** and **Ansible** in an automated workflow.

## Overview:

The goal of this project is to:

- Provision infrastructure using **Infrastructure as Code (IaC)** with Terraform
- Configure EC2 instances using **Ansible**
- Build a reproducible and scalable deployment process

This setup follows DevOps practices by separating **infrastructure provisioning** from **configuration management**.

---

## Project Structure

### Terraform Files:

- `main.tf` — Core Terraform configuration
- `variables.tf` — Input variable definitions
- `terraform.tfvars` — Variable values for flexible configuration
- `backend.tf` — Remote backend configuration for Terraform state management in S3
- `instance.tf` — EC2 instance resource definitions
- `security-group.tf` — Security group rules for network access

### Ansible Files:

- `inventory.ini` — Inventory file used by Ansible to connect to EC2 instances
- `playbook.yml` — Playbook used to configure the provisioned servers

---

## Technologies Used

- **Terraform** — Infrastructure provisioning
- **Ansible** — Configuration management
- **AWS** — Cloud provider used for hosting the infrastructure

---

## Workflow

### Terraform:

Terraform is used to create the required AWS infrastructure, including:

- 2 EC2 instances:
  - Web server (Nginx)
  - Database server
- 2 security groups:
  - `nginx-sg`
  - `database-sg`

#### Inbound Rules:

- Port `22` (SSH) is allowed only from the administrator's IP
- Ports `80` (HTTP) and `443` (HTTPS) are open to the public for the web server
- Port `3306` (MySQL) is restricted so only the web server can access the database server

#### Outbound Rules:

- Outbound traffic is allowed by default

#### Backend

Terraform state is stored remotely in an **S3 bucket**, which helps keep the `terraform.tfstate` file out of the Git repository and improves state management.

#### Variables:

Variables are separated into `variables.tf` and `terraform.tfvars` to make the configuration easier to manage, reuse, and update.

### Ansible:

Ansible is used after infrastructure provisioning to configure the EC2 instances.

- The `inventory.ini` file defines connection details such as:
  - server IP addresses
  - SSH username
  - SSH private key path

- The `playbook.yml` file is then used to:
  - update package lists
  - install required software
  - start services
  - enable services at boot

---

## How to Use?

```bash
# Initialize Terraform
terraform init

# Preview the execution plan
terraform plan

# Provision infrastructure
terraform apply

# Run Ansible playbook
ansible-playbook -i inventory.ini playbook.yml

# Destroy infrastructure
terraform destroy
```
The `--auto-approve` flag can be used with `terraform apply` and `terraform destroy` to run commands without manual confirmation.

---

This project demonstrates how Terraform and Ansible can be combined to automate infrastructure provisioning and server configuration on AWS. It highlights key DevOps principles such as Infrastructure as Code, automation, and scalable environment design.