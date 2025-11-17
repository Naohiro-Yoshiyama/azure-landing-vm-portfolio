# 🚀 Azure VM Landing Environment（個人ポートフォリオ）

Azure の基礎リソース（VNet / Subnet / NSG / Public IP / Linux VM）を  
**Bicep による IaC（Infrastructure as Code）で自動構築**した個人ポートフォリオです。

---

# 📦 構成概要

- Resource Group  
- Virtual Network（10.0.0.0/16）
  - Subnet-web（10.0.1.0/24）
  - Subnet-bastion（10.0.2.0/24）
- Network Security Group（Allow-SSH / Allow-HTTP）
- Public IP  
- NIC  
- Linux VM（Ubuntu 20.04 / B2s）  
- Storage Account  

---

```mermaid
flowchart LR
    Internet["🌐 Internet"] --> PublicIP["📘 Public IP"]
    PublicIP --> NIC["🔌 NIC"]
    NIC --> VM["💻 Linux VM"]

    VM --> SubnetWeb["Subnet: web"]
    SubnetWeb --> VNet["VNet (10.0.0.0/16)"]

    SubnetBastion["Subnet: bastion"] --> VNet

    NSG["🛡️ NSG (Allow SSH/HTTP)"] --> SubnetWeb

    Storage["📦 Storage Account"] --> VNet
```

### 🌐 VNet / Subnet

10.0.0.0/16 のアドレス空間を持つ VNet を作成し、
Web（10.0.1.0/24）および Bastion（10.0.2.0/24）を分離しています。
<img width="1612" height="277" alt="VNet" src="https://github.com/user-attachments/assets/3697c387-95b2-479c-9766-86d8ebd1d050" />
<img width="1639" height="310" alt="Subnet" src="https://github.com/user-attachments/assets/7aa43c29-e9d9-4ad1-9b7f-32f0ba2fa3db" />

### 🛡️ Network Security Group（NSG）

Allow-SSH(22) / Allow-HTTP(80) のみ許可し、最小限かつシンプルな初期構成 で公開しています。
<img width="1631" height="655" alt="NSG" src="https://github.com/user-attachments/assets/951a689b-11a6-42c4-9a91-00d9ae66fe65" />

### 💻 Virtual Machine（VM）

B2s（2vCPU / 4GB）サイズの Ubuntu 20.04 LTS をデプロイ。
Public IP 経由で SSH / HTTP が動作確認済み。
<img width="1617" height="329" alt="VM" src="https://github.com/user-attachments/assets/b50b132b-6eb0-4225-92d0-b5e8958480d9" />

## 🌐 Public IP の確認
この VM に割り当てられた Public IP は以下です。

<img width="1601" height="248" alt="Public IP" src="https://github.com/user-attachments/assets/4bb6fd50-051a-4af4-95f2-f83fe72f1b11" />

---

🔌 HTTP 通信確認（curl）
ローカル PC または VM 内部から curl で HTTP 応答を確認しました。

```bash
curl http://<Public-IP>
```
<img width="1115" height="628" alt="HTTP 通信確認（curl）" src="https://github.com/user-attachments/assets/a6ce7fb5-ad6c-42e2-a02a-4669ce578eb4" />

nginx のデフォルトページが返り、HTTP 通信が成功していることを確認できます。

