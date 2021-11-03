targetScope = 'resourceGroup'

param users array
param storageAccountName string
param storageAccountKey string
param configStorage array

var mounts = [for user in users: {
  name: user
  azureFile: {
    readOnly: false
    storageAccountName: storageAccountName
    storageAccountKey: storageAccountKey
  }
}]

var finalMounts = concat(mounts, configStorage)

output mountsExt array = finalMounts
