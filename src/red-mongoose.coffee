config = require './configuration'
RedisCacheClient = require './clients/redis'

class RedMongoose
  constructor: (@redisConfiguration, @mongoConfiguration) -> 
    @configurations =
      "redis": new config.RedisConfiguration @redisConfiguration
      "mongo": new config.MongoConfiguration @mongoConfiguration 
      
    @clients = 
      "redis": new RedisCacheClient(@configurations.redis)
  
  
module.exports = RedMongoose



  