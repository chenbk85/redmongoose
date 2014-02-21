EventEmitter = (require 'events').EventEmitter

module.exports = class CacheClient extends EventEmitter
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
    

