targetScope = 'resourceGroup'

@description('リソース名のプレフィックス（例: demo）')
param prefix string = 'demo'

@description('デプロイ先リージョン。既定はリソースグループの場所')
param location string = resourceGroup().location

@description('VM の管理者ユーザー名')
param adminUsername string

@secure()
@description('VM の管理者パスワード（デモ用。本番では SSH キー推奨）')
param adminPassword string

@description('VM サイズ')
param vmSize string = 'Standard_B2s'

@description('Storage Account の SKU')
param storageSku string = 'Standard_LRS'

//
// VNet
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

//
// NSG（Web サブネット用）
//
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

//
// Subnet（Web）
//
resource subnetWeb 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: '${vnet.name}/subnet-web'
  properties: {
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroup: {
      id: nsgWeb.id
    }
  }
}

//
// Subnet（Bastion / 運用用 – 今は未使用だが将来拡張用）
//
resource subnetBastion 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: '${vnet.name}/subnet-bastion'
  properties: {
    addressPrefix: '10.0.2.0/24'
  }
}

//
// Public IP（Standard + Static）
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

//
// NIC
//
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
// Storage Account
//
resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: toLower('${prefix}st${uniqueString(resourceGroup().id)}')
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

//
// Linux VM（Ubuntu）
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

output vmPublicIp string = publicIp.properties.ipAddress
