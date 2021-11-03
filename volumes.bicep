param storageAccountName string
param storageAccountKey string

var users = json(loadTextContent('users.json'))

var configVolume = [
  {
    name: 'config'
    azureFile: {
      readOnly: false
      shareName: 'config'
      storageAccountName: storageAccountName
      storageAccountKey: storageAccountKey
    }
  }
]

var userVolumes = [for user in users: {
  name: user
  azureFile: {
    readOnly: false
    shareName: user
    storageAccountName: storageAccountName
    storageAccountKey: storageAccountKey
  }
}]

output volumes array = concat(configVolume, userVolumes)
