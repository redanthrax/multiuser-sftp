var users = json(loadTextContent('users.json'))

var configMount = [
  {
    mountPath: '/etc/config'
    name: 'config'
    readOnly: true
  }
]

var userMounts = [for user in users: {
  mountPath: '/mnt/${user}'
  name: user
  readOnly: false
}]

output volumeMounts array = concat(configMount, userMounts)
