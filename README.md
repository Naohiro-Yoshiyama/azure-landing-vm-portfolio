# Azure VM Landing Environment（個人ポートフォリオ）

このリポジトリは、私（Naohiro Yoshiyama）が Azure を用いて  
**VNet / Subnet / NSG / Public IP / Linux VM を IaC（Bicep）で構築できるスキル** を示すためのポートフォリオです。

---

## 🌐 構成概要（実際にデプロイ済み）

- Resource Group  
- Virtual Network（10.0.0.0/16）
  - Subnet-web（10.0.1.0/24）
  - Subnet-bastion（10.0.2.0/24）
- Network Security Group（Allow-SSH / Allow-HTTP）
- Public IP（Standard）
- NIC
- Linux VM（Ubuntu 20.04 / B2s）
- Storage Account

---

## 🧱 アーキテクチャ図

本環境は以下の構成でデプロイされています。

- VNet / Subnet（Web・Bastion）
- Network Security Group（Allow-SSH / Allow-HTTP）
- Public IP
- NIC
- Linux VM（Ubuntu）
- Storage Account

※ Mermaid 図（docs/architecture/diagram.mmd）を使用して作成

    NSG[NSG] --> SubnetWeb
    Storage[Storage Account] --> VNet
![Uploading VNet.png…]()
