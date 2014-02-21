redis = require 'redis'
mongoose = require 'mongoose'

config = require './configuration'
EventEmitter = (require 'events').EventEmitter

class CacheClient extends EventEmitter
  constructor: (@configuration) ->
    @connect()
    
  connect: ->
    
  setupListener: (eventName, callback) ->
  
  ###Keys###
  getKeyType: (key, cb) ->
    
  keyExists: (key, cb) ->
  
  setTTLInSeconds: (key, seconds, cb) ->
  
  getTTLInSeconds: (key, cb) ->
  
  setExpirationDate: (key, unixTimestamp, cb) ->
  
  removeExpiration: (key, cb) ->
    
  rename: (key, newkey, cb) ->
    
  ###Hashes###
  
  deleteHashField: (key, field, cb) ->
    
  hashFieldExists: (key, field, cb) ->
    
  getHashField: (key, field, cb) ->
    
  getAllOfHash: (key, cb) ->
    
  incrementHashFieldByInteger: (key, field, integer, cb) ->
    
  incrementHashFieldByFloat: (key, field, float, cb) ->
    
  getAllHashFields: (key, cb) ->
    
  getAllHashValues: (key, cb) ->
    
  getNumberOfHashFields: (key, cb) ->
    
  getHashMultipleFields: (key, fields, cb) ->
  
  setHashMultipleFields: (key, fieldsAndValues, cb) ->
    
  setHashFieldStringValue: (key, field, value, cb) ->
    
  setHashFieldIfNotExists: (key, field, value, cb) ->
    
class RedisCacheClient extends CacheClient
  connect: ->
    @client = redis.createClient(
      @configuration.getPort(), 
      @configuration.getHost(), 
      @configuration.getNodeRedisOptions()
    )
  

  #redis has "ready", ("connect"), "error", "end", "drain", and "idle"
  setupListener: (eventName, callback) -> 
    @client.on eventName, callback

  DESTROYALLKEYS: (cb) ->
    @client.flushall cb
  
  #returns string, list, set, zset, hash
  getKeyType: (key, cb) -> 
    @client.type key, cb
  
  #returns 1(success) or 0(failure)
  keyExists: (key, cb) -> 
    @client.exists key, cb

  setTTLInSeconds: (key, seconds, cb) ->
    @client.expire key, seconds, cb
    
  #negative values signal error
  getTTLInSeconds: (key, cb) ->
    @client.ttl key, cb


  setExpirationDate: (key, unixTimestamp, cb) ->
    @client.expireat key, unixTimestamp, cb

  removeExpiration: (key, cb) ->
    @client.persist key, cb

  #response unknown, discover through testing
  rename: (key, newkey, cb) ->
    @client.rename key, newkey, cb
  
  ###Hashes###

  #returns number of fields removed
  deleteHashField: (key, field, cb) ->
    @client.hdel key, field, cb

  hashFieldExists: (key, field, cb) ->
    @client.hexists key, field, cb

  #returns the value of the field or nil
  getHashField: (key, field, cb) ->
    @client.hget key, field, cb

  #returns an object of the hash
  getAllOfHash: (key, cb) ->
    @client.hgetall key, (err, results) ->
      if err? then return cb err, results
      hash = {}
      indices = (i for i in [0...results.length] by 2)
      for index in indices
        hash[results[index]] = results[index+1]
      cb err, hash

  #returns field after increment
  incrementHashFieldByInteger: (key, field, integer, cb) ->
    @client.hincrby key, field, integer, cb

  incrementHashFieldByFloat: (key, field, float, cb) ->
    @client.hincrbyfloat key, field, float, cb

  #returns list of fields in hash
  getAllHashFields: (key, cb) ->
    @client.hkeys key, cb
  
  #returns list of values in hash
  getAllHashValues: (key, cb) ->
    @client.hvals key, cb
    

  getNumberOfHashFields: (key, cb) ->
    @client.hlen key, cb

  getHashMultipleFields: (key, fields, cb) ->
    @client.hmget key, fields, cb

  setHashMultipleFields: (key, fieldsAndValues, cb) ->
    @client.hmset key, fieldsAndValues, cb

  setHashFieldStringValue: (key, field, value, cb) ->
    @client.hset key, field, value, cb

  setHashFieldIfNotExists: (key, field, value, cb) ->
    @client.hsetnx key, field, value, cb
    
  
    
  
    
module.exports.RedisCacheClient = RedisCacheClient
    
  
class MongoCacheClient extends CacheClient



  