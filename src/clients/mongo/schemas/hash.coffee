mongoose = require 'mongoose'
Schema = mongoose.Schema

hashSchema = new Schema 
  key:
    type: String
    index: true
  fields: Object
  
hashSchema.statics.accessFieldOfHashAtKey = (key,field, cb) ->
  @findOne({key: key})
    .select('fields')
    .lean()
    .exec (err, doc) ->
      if err? then return cb err, doc
      unless doc? then return cb err,null
      cb err, doc.fields?[field]

hashSchema.statics.setFieldOfHashAtKey = (key, field, value, cb) ->
  updateObject = 
    "$set": {}
  updateObject['$set']['fields.' + field] = value
  @update key:key, updateObject,{upsert:true}, cb
  
hashSchema.statics.deleteFieldOfHashAtKey = (key, field, cb) ->
  updateObject =
    "$unset": {}
  updateObject['$unset']['fields.' + field] = ""
  @update key:key, updateObject, cb
  
hashSchema.statics.fieldExists = (key, field, cb) ->
  @accessFieldOfHashAtKey key, field, (err, doc) ->
    if err? then return cb err, doc
    unless doc? then return cb err, 0
    cb err, 1
    
hashSchema.statics.getEntireHash = (key, cb) ->
  @findOne({key:key})
    .select('fields')
    .lean()
    .exec (err, doc) ->
      if err? then return cb err, doc
      unless doc? then return cb err, null
      cb err, doc.fields
      
hashSchema.statics.incrementField = (key, field, integer, cb) ->
  updateObject = 
    "$inc": {}
  updateObject["$inc"]['fields.'+ field] = integer
  @findOneAndUpdate key:key, updateObject,{select: 'fields.'+ field},(err, doc) ->
    if err? then return cb err, doc
    unless doc? then return cb err, null
    return cb err, doc.fields?[field]
    
hashSchema.statics.getListOfFields = (key, cb) ->
  @getEntireHash key, (err, hash) ->
    if err? then return cb err, hash
    unless hash? then return cb err, []
    cb err, (field for field of hash)
      
hashSchema.statics.getListOfValues = (key, cb) ->
  @getEntireHash key, (err, hash) ->
    if err? then return cb err, hash
    unless hash? then return cb err, []
    cb err, (value for field, value of hash)

hashSchema.statics.getNumberOfHashFields = (key, cb) ->
  @getEntireHash key, (err, hash) ->
    if err? then return cb err, hash
    unless hash? then return cb err, 0
    cb err, (field for field of hash).length
    
hashSchema.statics.getMultipleHashFields = (key, fields, cb) ->
  selectString = ""
  for field in fields
    selectString += 'fields.' + field + " "
  @findOne({key:key})
    .select(selectString)
    .lean()
    .exec (err, doc) ->
      if err? then return cb err, doc
      unless doc? then return cb err, null
      cb err, doc.fields

hashSchema.statics.setMultipleHashFields = (key, hashUpdate, cb) ->
  updateObject = 
    '$set': {}
  updateObject['$set']['fields.'+property] = value for property, value of hashUpdate
  @update key:key, updateObject,{upsert:true}, cb
  
      
hashSchema.statics.setFieldOfHashAtKeyIfNotExists = (key, field, value, cb) ->
  @fieldExists key, field, (err, exists) =>
    if err? then return cb err, 0
    if exists then return cb err, 0
    @setFieldOfHashAtKey key, field, value, cb

      
module.exports = hashSchema
  
  