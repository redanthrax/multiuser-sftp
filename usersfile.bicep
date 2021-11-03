targetScope = 'resourceGroup'

param storageAccountName string
param storageAccountKey string

var filename = 'users.conf'
param utcValue string = utcNow()
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'deployscript-upload-file-${utcValue}'
  location: resourceGroup().location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: storageAccountName
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storageAccountKey
      }
      {
        name: 'CONTENT'
        value: loadTextContent('users.conf')
      }
    ]
    scriptContent: 'echo $CONTENT > ${filename} && az storage file upload --source ${filename} -s config'
  }
}
