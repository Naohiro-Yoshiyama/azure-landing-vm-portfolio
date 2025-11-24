targetScope = 'resourceGroup'

//
// ───── パラメーター ──────────────────────────────
//

@description('リソース名のプレフィックス（例: demo → demo-vnet / demo-vm-web など）')
param prefix string = 'demo'

@description('デプロイ先リージョン。既定はリソースグループの場所')
param location string = resourceGroup().location

@description('VM の管理者ユーザー名')
param adminUsername string

@secure()
@description('VM の管理者パスワード（デモ用。本番では SSH キー推奨）')
param adminPassword string

@description('VM サイズ（ポートフォリオ用の小さめインスタンス）')
param vmSize string = 'Standard_B2s'

//
// ───── Virtual Network & Subnets ────────────────
// 10.0.0.0/16 を Web / Bastion の 2 つの /24 に分割
//

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

// Web サブネット用 NSG（SSH / HTTP を許可）
resource nsgWeb 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: '${prefix}-nsg-web'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-SSH'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allow-HTTP'
        properties: {
          priority: 1010
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Web サブネット（NSG を関連付け）
resource subnetWeb 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: '${vnet.name}/subnet-web'
  properties: {
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroup: {
      id: nsgWeb.id
    }
  }
}

// Bastion / 運用用サブネット（将来用に確保）
resource subnetBastion 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: '${vnet.name}/subnet-bastion'
  properties: {
    addressPrefix: '10.0.2.0/24'
  }
}

//
// ───── Public IP & NIC ──────────────────────────
//

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${prefix}-pip-web'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-nic-web'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetWeb.id
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

//
// ───── Linux VM（Web サーバー用） ────────────────
// Ubuntu 20.04 LTS / Premium_LRS OS ディスク
//

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: '${prefix}-vm-web'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${prefix}-vm-web'
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        // デモ用にパスワード認証を有効化（本番では SSH キー推奨）
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          // 小さめ VM でもサクサク動くよう Premium_LRS を指定
          storageAccountType: 'Premium_LRS'
        }
        diskSizeGB: 64
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

//
// ───── Outputs（README に転記しやすい用）────────
//

@description('デプロイされた VM の Public IP')
output vmPublicIp string = publicIp.properties.ipAddress

@description('SSH 接続コマンドの例')
output sshCommand string = 'ssh ${adminUsername}@${publicIp.properties.ipAddress}'

@description('HTTP アクセス用 URL の例')
output httpUrl string = 'http://${publicIp.properties.ipAddress}'
