mongoose = require 'mongoose'
_ = require 'lodash'
CacheClient = require './../prototype'

hashSchema = require './schemas/hash'

class MongoCacheClient extends CacheClient
  connect: ->
    mongoose.connect @configuration.getURI(), @configuration.getMongooseOptions()
    @client = mongoose.connection
    @registerModels()
    @setupMongooseConnectionListeners()
  
  setupMongooseConnectionListeners: ->
    @client.on 'connected', -> @emit 'ready'
    
  setupListener: (event, cb) ->
    @on event, cb

  registerModels: -> 
    @Hash = mongoose.model 'Hash', hashSchema
    
  destroyAllHashes: (cb) ->
    @client.collections.hashes.drop()
    cb()

  #returns number of fields removed
  deleteHashField: (key, field, cb) ->
    @Hash.deleteFieldOfHashAtKey key, field, cb

  setHashField: (key, field, value, cb) ->
    @Hash.setFieldOfHashAtKey key, field, value, cb
    
  getHashField: (key, field, cb) ->
    @Hash.accessFieldOfHashAtKey key, field, cb
    
  hashFieldExists: (key, field, cb) ->
    @Hash.fieldExists key, field, cb
  
    
###
  hashFieldExists: (key, field, cb) ->
    @client.hexists key, field, cb

  #returns the value of the field or nil
  getHashField: (key, field, cb) ->
    @client.hget key, field, cb

  #returns an object of the hash
  getHashAsObject: (key, cb) ->
    @client.hgetall key, cb

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
    @client.hmget key, fields, (err, fieldValues) ->
      if err? then return cb err, fieldValues
      returnHash = {}
      for index in [0...fields.length]
        returnHash[fields[index]] = fieldValues[index]
      cb err, returnHash


  setHashMultipleFields: (key, hashUpdate, cb) ->
    @client.hmset key, hashUpdate, cb



  setHashFieldIfNotExists: (key, field, value, cb) ->
    @client.hsetnx key, field, value, cb
    
### 
module.exports = MongoCacheClient
