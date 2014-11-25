debug = require('debug')('vocabulary:mongo-wordlists')


class MongoWordlists
  constructor: (@db, @seed) ->
    @wordlists = db.collection('wordlists')

  find: (filter, callback) ->
    query = {
      $or:[
        {name: { $regex: filter, $options: 'i'}},
        {author: { $regex: filter, $options: 'i'}}
      ]
    }
    query = {} unless filter
    @wordlists.find(query).toArray (err, wordlists) ->
        callback(err, wordlists)

  findById: (id, callback) ->
    @wordlists.findById id, (err, wordlist) ->
      debug('findById', err, wordlist)
      callback(err, wordlist)


  add: (wordlist, callback) ->
    debug('add', wordlist)
    wordlist.createDate = new Date()
    wordlist.modifiedDate = new Date()
    @wordlists.insert wordlist, (err, addedLists) ->
      debug('add', addedLists)
      callback(err, addedLists[0]._id)

  update: (wordlist, callback) ->
    wordlists = @wordlists
    id = wordlist._id
    delete(wordlist._id)
    wordlist.modifiedDate = new Date()
    @findById id, (err, found) ->
      return callback('wordlist not found, id: ' + id) unless found
      wordlists.updateById id, wordlist, (err) ->
        callback(err, wordlist)

  remove: (wordlistOrId, callback) ->
    wordlists = @wordlists
    id = wordlistOrId._id or wordlistOrId
    @findById id, (err, wordlist) ->
      return callback('wordlist not found, id: ' + id) unless wordlist
      wordlists.removeById id, (err) ->
        callback(err, wordlist)

  reset: (callback) ->
    wordlists = @wordlists;
    seed = @seed;
    wordlists.drop (err, data) ->
      wordlists.insert seed, (err, data) ->
        callback(err)

module.exports = MongoWordlists
