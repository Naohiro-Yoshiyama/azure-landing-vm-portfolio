# Azure VM Landing Environment (Portfolio Sample)

このリポジトリは、Azure インフラ構築スキルを示すための **ポートフォリオ用テンプレート** です。  
Bicep テンプレートを使って、以下の構成を一括デプロイできます。

---

## 🌐 構成概要

- リソースグループ（デプロイ時に指定）
- Virtual Network（VNet）
  - Web サブネット
  - Bastion / 運用用サブネット（将来拡張用）
- Network Security Group（NSG）
  - SSH(22) / HTTP(80) を許可
- Public IP
- Network Interface（NIC）
- Linux VM（Ubuntu）
- Storage Account（汎用用途・ログ保管など）

---

## 🧱 アーキテクチャ図（Mermaid）

`docs/diagram.mmd` に定義しています。Mermaid 対応エディタや GitHub 上でプレビューできます。

```mermaid
flowchart LR
    Internet --> PublicIP
    PublicIP --> NIC
    NIC --> VM[Linux VM]

    VM --> SubnetWeb[Subnet: web]
    SubnetWeb --> VNet[VNet]

    SubnetBastion[Subnet: bastion] --> VNet

    NSG[NSG (SSH/HTTP許可)] --> SubnetWeb
    Storage[Storage Account] --> VNet
