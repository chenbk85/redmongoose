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
    fields: {}
  updateObject['fields'][field] = value
  @update key:key, updateObject,{upsert:true}, cb
  
hashSchema.statics.deleteFieldOfHashAtKey = (key, field, cb) ->
  updateObject =
    "$unset":
      "fields": {}
  updateObject['$unset']['fields'][field] = ""
  @update key:key, updateObject, cb
  
hashSchema.statics.fieldExists = (key, field, cb) ->
  @accessFieldOfHashAtKey key, field, (err, doc) ->
    if err? then return cb err, doc
    unless doc? then return cb err, 0
    cb err, 1
    


      
module.exports = hashSchema
  
  