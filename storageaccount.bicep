targetScope = 'resourceGroup'

param storageAccountName string

var users = json(loadTextContent('users.json'))
//deploy storage account
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku:{
    name: 'Standard_LRS'
  }
}

//deploy config share and user shares
resource configshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01' = {
  name: toLower('${storageaccount.name}/default/config')
}

resource fileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-06-01' = [for name in users: {
  name: toLower('${storageaccount.name}/default/${name}')
}]

output account object = {
  name: storageaccount.name
  key: listKeys(storageaccount.id, '2019-06-01').keys[0].value
}
