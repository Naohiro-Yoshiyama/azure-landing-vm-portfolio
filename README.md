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
flowchart LR
    Internet:::net --> PublicIP:::resource
    PublicIP --> NIC:::resource
    NIC --> VM[Linux VM]:::compute

    VM --> SubnetWeb[Subnet: web]:::subnet
    SubnetWeb --> VNet[VNet 10.0.0.0/16]:::vnet

    SubnetBastion[Subnet: bastion]:::subnet --> VNet

    NSG[NSG (Allow SSH/HTTP)]:::nsg --> SubnetWeb
    Storage[Storage Account]:::storage --> VNet

classDef resource fill:#87CEFA,stroke:#333,stroke-width:1px;
classDef compute fill:#FFD580,stroke:#333,stroke-width:1px;
classDef vnet fill:#9FE2BF,stroke:#333,stroke-width:1px;
classDef subnet fill:#D7FFEA,stroke:#333,stroke-width:1px;
classDef nsg fill:#FFB6C1,stroke:#333,stroke-width:1px;
classDef storage fill:#E6E6FA,stroke:#333,stroke-width:1px;
classDef net fill:#B0C4DE,stroke:#333,stroke-width:1px;
