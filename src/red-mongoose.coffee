config = require './configuration'
client = require './client'

class RedMongoose
  constructor: (@redisConfiguration, @mongoConfiguration) -> 
    @configurations =
      "redis": new config.RedisConfiguration @redisConfiguration
      "mongo": new config.MongoConfiguration @mongoConfiguration 
      
    @clients = 
      "redis": new client.RedisCacheClient(@configurations.redis)
      
      
      
  
module.exports = RedMongoose



  