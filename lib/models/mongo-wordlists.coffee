debug = require('debug')('vocabulary:mongo-wordlists')


class MongoWordlists
  constructor: (@db, @seed) ->
    @wordlists = db.collection('wordlists')

  find: (filter, callback) ->
    query = {
      $or:[
        {name: { $regex: filter, $options: 'i'}},
        {author: { $regex: filter, $options: 'i'}},
        {title: { $regex: filter, $options: 'i'}}
      ]
    }
    query = {} unless filter
    @wordlists.find(query).toArray (err, wordlists) ->
        callback(err, wordlists)

  findById: (id, callback) ->
    @wordlists.findOne {_id: id}, (err, wordlist) ->
      callback(err, wordlist)


  add: (wordlist, callback) ->
    @wordlists.insert wordlist, (err, addedwordlist) ->
      debug(addedwordlist)
      callback(err, addedwordlist._id)

  update: (wordlist, callback) ->
    wordlists = @wordlists
    id = wordlist._id
    @findById id, (err, found) ->
      return callback('wordlist not found, id: ' + id) unless found
      wordlists.update {_id: wordlist._id}, wordlist, (err) ->
        callback(err, wordlist)

  remove: (wordlistOrId, callback) ->
    wordlists = @wordlists
    id = wordlistOrId._id or wordlistOrId
    @findById id, (err, wordlist) ->
      return callback('wordlist not found, id: ' + id) unless wordlist
      wordlists.remove {_id: id}, (err) ->
        callback(err, wordlist)

  reset: (callback) ->
    wordlists = @wordlists;
    seed = @seed;
    wordlists.drop (err, data) ->
      wordlists.insert seed, (err, data) ->
        callback(err)

module.exports = MongoWordlists
