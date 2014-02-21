RedMongoose = require '../src/red-mongoose'
configuration = require '../src/configuration'
_ = require 'lodash'
describe "RedMongoose", ->
  describe "Redis", ->
    describe "configuration", ->
      describe "(without parameters)", ->
        config = null
        beforeEach ->
          config = new configuration.RedisConfiguration()
        it "should generate a RedisConfiguration instance", ->
          expect(config instanceof configuration.RedisConfiguration).toBeTruthy()
        describe "by default", ->
          it "should have default port as 6379", ->
            expect(config.getPort()).toBe 6379
          it "should have default host as localhost", ->
            expect(config.getHost()).toBe "localhost"
          it "should have null password", ->
            expect(config.getPassword()).toBe null
          it "should have default enabled value set to false", ->
            expect(config.getEnabled()).toBe false
          it "should have empty node_redis_options", ->
            expect(_.isEmpty config.getNodeRedisOptions()).toBe true
      describe "(with parameters)", ->
        config = null
        beforeEach ->
          config = null
        it "should merge correctly when passed an empty configuration", ->
          config = new configuration.RedisConfiguration({})
          expect(_.isEqual config.defaultParameters, config.configuration).toBe true
        it "should allow overrides of simple values", ->
          options =
            port: 7000
            password: "hello"
          config = new configuration.RedisConfiguration(options)
          expect(config.getPassword()).toBe "hello"
          expect(config.getPort()).toBe 7000
        it "should allow overrides of the nested values", ->
          options =
            node_redis_options:
              "socket_nodelay":false
          config = new configuration.RedisConfiguration options
          expect(config.getNodeRedisOptions().socket_nodelay).toEqual options.node_redis_options.socket_nodelay
        it "should put the password into the node_redis_options", ->
          options =
            password: "hello"
          config = new configuration.RedisConfiguration options
          expect(config.getNodeRedisOptions().auth_pass).toEqual options.password

  describe "Mongo", ->
    describe "configuration", ->
      describe "(without parameters)", ->
        config = null
        beforeEach ->
          config = new configuration.MongoConfiguration()
        it "should generate a MongoConfiguration instance", ->
          expect(config instanceof configuration.MongoConfiguration).toBeTruthy()
        describe "by default", ->
          it "should have default port as 27017", ->
            expect(config.getPort()).toBe 27017
          it "should have the default uri as localhost", ->
            expect(config.getURI()).toBe "localhost"
          it "should have null password", ->
            expect(config.getPassword()).toBe null
          it "should have the default enabled value set to false", ->
            expect(config.getEnabled()).toBe false
          it "should have empty mongoose options", ->
            expect(_.isEmpty config.getMongooseOptions()).toBe true
      describe "(with parameters)", ->
        config = null
        beforeEach ->
          config = null
        it "should merge correctly when passed an empty configuration", ->
          config = new configuration.RedisConfiguration({})
          expect(_.isEqual config.defaultParameters, config.configuration).toBe true
        it "should allow overrides of simple values", ->
          options =
            port: 7000
            password: "hello"
          config = new configuration.MongoConfiguration(options)
          expect(config.getPassword()).toBe "hello"
          expect(config.getPort()).toBe 7000
        it "should allow overrides of the nested values", ->
          options =
            mongoose_options:
              replset: "replica"
          config = new configuration.MongoConfiguration(options)
          expect(config.getMongooseOptions().replset).toEqual "replica"
        
            
        
          
            
        
           