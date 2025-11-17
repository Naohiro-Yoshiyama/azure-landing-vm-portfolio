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

```mermaid
flowchart LR
    Internet --> PublicIP[Public IP]
    PublicIP --> NIC[NIC]
    NIC --> VM[Linux VM]

    VM --> SubnetWeb[Subnet web]
    SubnetWeb --> VNet[VNet]

    SubnetBastion[Subnet bastion] --> VNet

    NSG[NSG] --> SubnetWeb
    Storage[Storage Account] --> VNet

### 🌐 VNet / Subnet

10.0.0.0/16 のアドレス空間を持つ VNet を作成し、
Web（10.0.1.0/24）および Bastion（10.0.2.0/24）を分離しています。

<img width="1612" height="277" alt="VNet" src="https://github.com/user-attachments/assets/13dea03c-d70c-455e-b150-ca24d3e3b6ee" />
<img width="1639" height="310" alt="Subnet" src="https://github.com/user-attachments/assets/2375dc51-71e0-42bf-8a82-b6b761018373" />
