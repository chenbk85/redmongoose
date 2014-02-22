RedMongoose = require '../src/red-mongoose'
_ = require 'lodash'
RedisCacheClient = require '../src/clients/redis/redis'
MongoCacheClient = require '../src/clients/mongo/mongo'

describe "RedMongoose", ->
  rm = new RedMongoose()
  describe "Redis", ->
    describe "client", ->
      client = rm.clients.redis
      beforeEach (done) ->
        client.DESTROYALLKEYS ->
          done()

      describe "hashes", ->
        it "should not detect the existence of a nonexistent field in a nonexistent hash", (done) ->
          client.hashFieldExists "testKey", "testField", (err, exists) ->
            expect(err).toBeNull()
            expect(exists).toBe 0
            done()
        it "should successfully create a hash field", (done) ->
          client.setHashField "testKey","testField","hello", (err, success) ->
            expect(err).toBeNull()
            expect(success).toBe 1
            done()
        it "should successfully detect the existence of an existent field in an existent hash", (done) ->
          client.setHashField "testKey","testField","hello", (err, success)->
            expect(err).toBeNull()
            expect(success).toBeTruthy()
            client.hashFieldExists "testKey","testField", (err, exists) ->
              expect(err).toBeNull()
              expect(exists).toBe 1
              done()
        it "should delete keys", (done) ->
          client.setHashField "testKey","testField","hello", ->
            client.deleteHashField "testKey","testField", (err, numberOfFieldsRemoved) ->
              expect(err).toBeNull()
              expect(numberOfFieldsRemoved).toBe 1
              client.hashFieldExists "testKey","testField", (err, exists) ->
                expect(err).toBeNull()
                expect(exists).toBeFalsy()
                done()
        it "should get hash fields", (done) ->
          client.setHashField "testKey","testField","hello", ->
            client.getHashField "testKey","testField", (err, fieldValue) ->
              expect(err).toBeNull()
              expect(fieldValue).toBe "hello"
              done()
        it "should get hash as object", (done) ->
          client.setHashField "testKey", "testFieldOne", "hello", ->
            client.setHashField "testKey", "testFieldTwo", "goodbye", ->
              client.getHashAsObject "testKey", (err, hash) ->
                expect(err).toBeNull()
                expectedHash = 
                  "testFieldOne":"hello"
                  "testFieldTwo":"goodbye"
                expect(_.isEqual(hash,expectedHash)).toBe true
                done()
        it "should increment a hash field by one", (done) ->
          client.setHashField "testKey","testField", 1, ->
            client.incrementHashFieldByInteger "testKey","testField",5, (err, newValue) ->
              expect(err).toBeNull()
              expect(newValue).toBe(6)
              done()
        it "should increment a hash field by a float", (done) ->
          client.setHashField "testKey","testField",2, ->
            client.incrementHashFieldByFloat "testKey","testField", 2.2, (err, newValue) ->
              expect(err).toBeNull()
              expect(newValue).toBeCloseTo 4.2
              done()
        
        it "should correctly list hash fields", (done) ->
          client.setHashField "multiTest", "one","blah", ->
            client.setHashField "multiTest","two","blah", ->
              client.getAllHashFields "multiTest", (err, results) ->
                expect(err).toBeNull()
                expectedArray = ["one","two"]
                expect(_.isEqual(expectedArray,results)).toBeTruthy()
                done()
                
        it "should correctly list hash values", (done) ->
          client.setHashField "multiTest", "one","blah", ->
            client.setHashField "multiTest","two","blah", ->
              client.getAllHashValues "multiTest", (err, results) ->
                expect(err).toBeNull()
                expectedArray = ["blah","blah"]
                expect(_.isEqual(expectedArray,results)).toBeTruthy()
                done()
                
        it "should correctly list the number of hash fields", (done) ->
          client.setHashField "multiTest", "one","blah", ->
            client.setHashField "multiTest","two","blah", ->
              client.getNumberOfHashFields "multiTest", (err, numberFields) ->
                expect(err).toBeNull()
                expect(numberFields).toBe 2
                done()
                
        it "should correctly get multiple hash fields", (done) ->
          client.setHashField "multiTest", "one","blah", ->
            client.setHashField "multiTest","two","blah", ->
              client.getHashMultipleFields "multiTest", ["one","two"], (err, fields) ->
                expect(err).toBeNull()
                expectedHash = 
                  "one":"blah"
                  "two":"blah"
                expect(_.isEqual(expectedHash,fields)).toBeTruthy()
                done()
        it "should correctly set multiple hash fields", (done) ->
          hashUpdate =
            "one":"blargh"
            "two":"blah"
          client.setHashMultipleFields "multiTest",hashUpdate, (err, success) ->
            expect(err).toBeNull()
            expect(success).toBeTruthy()
            client.getHashField "multiTest","one",(err, field) ->
              expect(err).toBeNull()
              expect(field).toBe "blargh"
              client.getHashField "multiTest","two",(err, field) ->
                expect(err).toBeNull()
                expect(field).toBe "blah"
                done()
        it "should correctly set a hash field correctly", (done) ->
          client.setHashField "testKey", "testField","testValue", (err, result) ->
            expect(err).toBeNull()
            expect(result).toBeTruthy()
            
            client.getHashField "testKey","testField", (err, field) ->
              expect(err).toBeNull()
              expect(field).toBe "testValue"
              done()
        it "should set a hash field if it doesn't exist", (done) ->
          client.setHashFieldIfNotExists "testKeyNotExists", "testField","testValue", (err, result) ->
            expect(err).toBeNull()
            expect(result).toBeTruthy()

            client.getHashField "testKeyNotExists","testField", (err, field) ->
              expect(err).toBeNull()
              expect(field).toBe "testValue"
              done()
        it "should not set a hash field if not exists", (done) ->
          client.setHashField "unique","testValue", "before", (err, result) ->
            expect(err).toBeNull()
            expect(result).toBeTruthy()
            
            client.setHashFieldIfNotExists "unique","testValue","after",(err, result) ->
              expect(err).toBeNull()
              expect(result).toBeFalsy()
              
              client.getHashField "unique","testValue",(err, field) ->
                expect(err).toBeNull()
                expect(field).toBe "before"
                done()
                
  describe "Mongo", ->
    describe "client", ->
      client = rm.clients.mongo
      
      describe "hashes", ->
        beforeEach (done) ->
          client.setHashField "create", "the", "db and collection", (err, success) ->
            client.destroyAllHashes ->
              done()
        it "should not detect the existence of a nonexistent field in a nonexistent hash", (done) ->
          client.hashFieldExists "testKey", "testField", (err, exists) ->
            expect(err).toBeNull()
            expect(exists).toBe 0
            done()
        it "should successfully create a hash field", (done) ->
          client.setHashField "testKey","testField","hello", (err, success) ->
            expect(err).toBeNull()
            expect(success).toBe 1
            done()
        it "should successfully detect the existence of an existent field in an existent hash", (done) ->
          client.setHashField "testKey","testField","hello", (err, success)->
            expect(err).toBeNull()
            expect(success).toBeTruthy()
            client.hashFieldExists "testKey","testField", (err, exists) ->
              expect(err).toBeNull()
              expect(exists).toBe 1
              done()
        it "should delete keys", (done) ->
          client.setHashField "testKey","testField","hello", (err, success)->
            expect(err).toBeNull()
            expect(success).toBe 1
            client.deleteHashField "testKey","testField", (err, numberOfFieldsRemoved) ->
              expect(err).toBeNull()
              expect(numberOfFieldsRemoved).toBe 1
              client.hashFieldExists "testKey","testField", (err, exists) ->
                done()
                expect(err).toBeNull()
                expect(exists).toBe 0
        it "should get hash fields", (done) ->
          client.setHashField "testKey","testField","hello", ->
            client.getHashField "testKey","testField", (err, fieldValue) ->
              expect(err).toBeNull()
              expect(fieldValue).toBe "hello"
              done()
        
                
            
          
      
      
      
        
            
        
          
            
        
           