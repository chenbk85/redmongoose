_ = require 'lodash'

class Configuration
  constructor: (@rawConfiguration) ->
    @validateAndMergeWithDefaults()

  validateAndMergeWithDefaults: ->
    @configuration = _.merge @defaultParameters, @rawConfiguration

  getPort: -> @configuration.port

  getPassword: -> @configuration.password

  getEnabled: -> @configuration.enabled


module.exports.RedisConfiguration = class RedisConfiguration extends Configuration
  constructor: (@rawConfiguration) ->
    @defaultParameters =
      port: 6379
      host: "localhost"
      password: null
      enabled: false
      node_redis_options: {}
    super(@rawConfiguration)

  validateAndMergeWithDefaults: ->
    super()
    @configuration.node_redis_options.auth_pass = @configuration.password if @configuration.password
    
  getNodeRedisOptions: -> @configuration.node_redis_options

  getHost: -> @configuration.host

module.exports.MongoConfiguration = class MongoConfiguration extends Configuration
  constructor: (@rawConfiguration) ->
    @defaultParameters =
      port: 27017
      uri: "localhost"
      password: null
      enabled: false
      mongoose_options: {}
    super(@rawConfiguration)
  
  getMongooseOptions: -> @configuration.mongoose_options
    
  getURI: -> @configuration.uri
