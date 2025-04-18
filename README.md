# 🌐 Azure Global Infrastructure with Terraform & Ansible

## 📖 Overview
This project automates the deployment of a **multi-region Azure infrastructure** using **Terraform** and configures the environment using **Ansible**.  
It follows a **hub-and-spoke** topology across **West Europe (Hub)**, **France Central**, and **East US**, with **Azure Traffic Manager** providing global load balancing.

![Project Diagram](Photos/azure-infra-with-terraform-ansible.gif)

---

## 🛠️ Technologies Used

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-7B42BC?style=flat&logo=terraform)](https://www.terraform.io/)  
[![Azure](https://img.shields.io/badge/Azure-Cloud-0089D6?style=flat&logo=microsoft-azure)](https://azure.microsoft.com)  
[![Ansible](https://img.shields.io/badge/Ansible-2.14+-EE0000?style=flat&logo=ansible)](https://www.ansible.com/)

---

## 🚀 Terraform Infrastructure

### ✅ Highlights

- Modular architecture using best practices
- Multi-region deployment: **West Europe (Hub)**, **France Central**, **East US**
- **Bidirectional VNet Peering** between all regions
- **Azure Traffic Manager** for global load balancing
- **Dedicated Bastion Host** for secure remote access
- **Network Security Groups** for application-layer isolation
- **Static IP addressing** with reserved range avoidance

---

### 📊 Terraform Graph
Generated using `terraform graph | dot -Tpng`:
![Terraform Graph](Photos/Terraform/graph/graph.png)

---

### 🌍 Regional Deployment Screenshots

#### 🟦 West Europe (Hub)
![West Europe](Photos/Terraform/Screenshots/westEurope01rg.png)

#### 🇫🇷 France Central
![France Central](Photos/Terraform/Screenshots/france01RG.png)

#### 🇺🇸 East US
![East US](Photos/Terraform/Screenshots/eastUS01RG.png)

---

## 🧪 Terraform Commands

### Initialize Terraform
terraform init

### Preview changes
terraform plan

![Plan](Photos/Terraform/Screenshots/Plan.png)

### Apply infrastructure
terraform apply

``` Apply complete! Resources: 50 added, 0 changed, 0 destroyed. ```


### Clean The infrastructure
terraform Destroy

![Destroy](Photos/Terraform/Screenshots/Destroy.png)

