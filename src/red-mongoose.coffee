config = require './configuration'
RedisCacheClient = require './clients/redis/redis'
MongoCacheClient = require './clients/mongo/mongo'
class RedMongoose
  constructor: (@redisConfiguration, @mongoConfiguration) -> 
    @configurations =
      "redis": new config.RedisConfiguration @redisConfiguration
      "mongo": new config.MongoConfiguration @mongoConfiguration 
      
    @clients = 
      "redis": new RedisCacheClient(@configurations.redis)
      "mongo": new MongoCacheClient(@configurations.mongo)
      
  
  
module.exports = RedMongoose



  