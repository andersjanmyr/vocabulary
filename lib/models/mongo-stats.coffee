debug = require('debug')('vocabulary:mongo-stats')

class MongoStats
  constructor: (@db, @seed) ->
    @stats = db.collection('stats')

  find: (filter, callback) ->
    query = {
      $or:[
        {author: { $regex: filter, $options: 'i'}}
      ]
    }
    query = {} unless filter
    @stats.find(query).toArray (err, stats) ->
        callback(err, stats)

  add: (stat, callback) ->
    debug('add', stat)
    @stats.insert stat, (err, addedLists) ->
      debug('add', addedLists)
      callback(err, addedLists[0]._id)

  reset: (callback) ->
    stats = @stats;
    seed = @seed;
    stats.drop (err, data) ->
      stats.insert seed, (err, data) ->
        callback(err)

module.exports = MongoStats

