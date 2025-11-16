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

## 🧱 アーキテクチャ図（Mermaid）

※ `docs/architecture/diagram.mmd` に格納

```mermaid
flowchart LR<img width="1612" height="277" alt="VNet" src="https://github.com/user-attachments/assets/3bf065b7-8dbc-45d1-a065-3c8b9b1f8a95" />

    Internet --> PublicIP[Public IP]
    PublicIP --> NIC[NIC]
    NIC --> VM[Linux VM]

    VM --> SubnetWeb[Subnet web]
    SubnetWeb --> VNet[VNet]

### 🌐 VNet / Subnet

10.0.0.0/16 のアドレス空間を持つ VNet を作成し、
Web（10.0.1.0/24）および Bastion（10.0.2.0/24）を分離しています。

    SubnetBastion[Subnet bastion] --> VNet
![Uploading VNet.png…]()

    NSG[NSG] --> SubnetWeb
    Storage[Storage Account] --> VNet
![Uploading VNet.png…]()
