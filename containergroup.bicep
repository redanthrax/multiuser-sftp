param storageAccountName string
param storageAccountKey string

module volumemounts './volumemounts.bicep' = {
  name: 'VolumeMounts'
}

module volumes './volumes.bicep' = {
  name: 'Volumes'
  params: {
    storageAccountName: storageAccountName
    storageAccountKey: storageAccountKey
  }
}

var envVars = 'sftp:Password123!:1001'
resource containergroup 'Microsoft.ContainerInstance/containerGroups@2021-07-01' = {
  name: 'sftp-group'
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: 'sftp'
        properties: {
          image: 'atmoz/sftp:debian'
          command: [
            'sleep 30'
            'cp /etc/config/users.conf /etc/sftp/users.conf'
            '/entrypoint'
          ]
          environmentVariables: [
            {
              name: 'SFTP_USERS'
              secureValue: envVars
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          ports:[
            {
              port: 22
              protocol: 'TCP'
            }
          ]
          volumeMounts: volumemounts.outputs.volumeMounts
        }
      }
    ]
    osType:'Linux'
    ipAddress: {
      type: 'Public'
      ports:[
        {
          port: 22
          protocol:'TCP'
        }
      ]
      dnsNameLabel: uniqueString(resourceGroup().id, deployment().name)
    }
    restartPolicy: 'OnFailure'
    volumes: volumes.outputs.volumes
  }
}
