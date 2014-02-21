RedMongoose = require '../src/red-mongoose'
_ = require 'lodash'
clients = require '../src/client'

describe "RedMongoose", ->
  describe "Redis", ->
    describe "client", ->
      rm = null
      client = null
      beforeEach (done) ->
        rm = new RedMongoose()
        client = new clients.RedisCacheClient(rm.configurations.redis)
        client.setupListener 'ready', ->
          client.DESTROYALLKEYS ->
            done()
          
      describe "hashes", ->
        it "should not detect the existence of a nonexistent field in a nonexistent hash", (done) ->
          client.hashFieldExists "testKey", "testField", (err, exists) ->
            expect(exists).toBeFalsy()
            done()
        it "should successfully create a hash field", (done) ->
          client.setHashFieldStringValue "testKey","testField","hello", (err, success) ->
            expect(success).toBeTruthy()
            done()
        it "should successfully detect the existence of an existent field in an existent hash", (done) ->
          client.setHashFieldStringValue "testKey","testField","hello", (err, success)->
            expect(success).toBeTruthy()
            client.hashFieldExists "testKey","testField", (err, exists) ->
              expect(exists).toBeTruthy()
              done()
        it "should delete keys", (done) ->
          client.setHashFieldStringValue "testKey","testField","hello", ->
            client.deleteHashField "testKey","testField", (err, numberOfFieldsRemoved) ->
              expect(numberOfFieldsRemoved).toBe 1
              client.hashFieldExists "testKey","testField", (err, exists) ->
                expect(exists).toBeFalsy()
                done()
        it "should get hash fields", (done) ->
          client.setHashFieldStringValue "testKey","testField","hello", ->
            client.getHashField "testKey","testField", (err, fieldValue) ->
              expect(fieldValue).toBe "hello"
              done()
        it "should get all of hash", (done) ->
          client.setHashFieldStringValue "testKey", "testFieldOne", "hello", ->
            client.setHashFieldStringValue "testKey", "testFieldTwo", "goodbye", ->
              
          
              
            
            
            
          
          
      
      

  describe "Mongo", ->
    describe "client", ->
        
            
        
          
            
        
           