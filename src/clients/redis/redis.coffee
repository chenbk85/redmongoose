redis = require 'redis'

CacheClient = require './../prototype'

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

  setHashField: (key, field, value, cb) ->
    @client.hset key, field, value, cb

  setHashFieldIfNotExists: (key, field, value, cb) ->
    @client.hsetnx key, field, value, cb
    
  ###Sorted Sets###
  
  sortedSetMemberExists: (key, member, cb) ->
    @client.zscore key, member, (error, score) ->
      if error? then return cb error, score
      if score is null then return cb error, false
      cb error, true
  
  addOrChangeSortedSetMember: (key, score, member, cb) ->
    @client.zadd key, score, member, cb
    
  getRankOfSortedSetMember: (key, member, cb) ->
    @client.zrevrank key, member, cb
    
    
  getScoreOfSortedSetMember: (key, member, cb) ->
    @client.zscore key, member, (err, scoreString) ->
      if err? or not scoreString? then return cb err, scoreString
      cb err, parseFloat(scoreString)
    
  getAmountOfMembersInSortedSet: (key, cb) ->
    @client.zcard key, cb
    
  addOrChangeMultipleMembersOfSortedSet: (key, scoresAndMembers,cb) ->
    if scoresAndMembers.length is 0 then return cb null, 0
    commands = [key]
    for scoreAndMemberObject in scoresAndMembers
      commands.push scoreAndMemberObject.score
      commands.push scoreAndMemberObject.member
    @client.zadd commands, cb
    
  getAmountOfMembersInScoreRange: (key, minScore, maxScore, cb) ->
    #score is inclusive
    @client.zcount key, minScore, maxScore, cb
    
  getMembersInRankRange: (key, minRank, maxRank, cb) ->
    @client.zrevrange key, minRank, maxRank, cb
    
  getMembersInRankRangeWithScore: (key, minRank, maxRank, cb) ->
    @client.zrevrange key, minRank, maxRank, "WITHSCORES", (error, results) =>
      @parseResultListAndExecuteCallback error, results, cb
      
  parseResultListAndExecuteCallback: (error, resultList, callback) ->
    if err? then return callback error, resultList
    unless resultList then return callback error, resultList
      
    resultArray = []
    elementIndices = (index for index in [0...resultList.length] by 2)
    
    for elementIndex in elementIndices
      elementObject = 
        member: resultList[elementIndex]
        score: parseFloat(resultList[elementIndex + 1])
      resultArray.push elementObject
    callback error, resultArray
    


    


module.exports = RedisCacheClient