targetScope = 'resourceGroup'

module sftpstorage './storageaccount.bicep' = {
  name: 'StorageDeployment'
  params: {
    storageAccountName: 'sftstorageaccounttest'
  }
}

module usersfile './usersfile.bicep' = {
  name: 'UsersFile'
  params: {
    storageAccountName: sftpstorage.outputs.account.name
    storageAccountKey: sftpstorage.outputs.account.key
  }
}

module containergroup './containergroup.bicep' = {
  name: 'ContainerGroup'
  params: {
    storageAccountName: sftpstorage.outputs.account.name
    storageAccountKey: sftpstorage.outputs.account.key
  }
}
