debug = require('debug')('vocabulary:mongo-stats')

class MongoStats
  constructor: (@db, @seed) ->
    @stats = @db.collection('statistics')

  find: (filter, callback) ->
    query = {
      $or:[
        {user: { $regex: filter, $options: 'i'}}
      ]
    }
    query = {} unless filter
    @stats.find(query).toArray (err, stats) ->
      callback(err, stats)

  byUser: (user, callback) ->
    query = {user: user}
    @stats.find(query).toArray (err, stats) ->
      return callback(err) if err
      count = stats.length
      perfect = stats.filter((stat) -> stat.tries == stat.words).length
      ok = stats.filter((stat) -> stat.tries < (stat.words * 1.5)).length - perfect
      bad = stats.filter((stat) -> stat.tries >= (stat.words * 1.5)).length
      callback(null, {
        count: count
        perfect: perfect
        ok: ok
        bad: bad,
        perfectPerc: parseInt(perfect / count * 100, 10)
        okPerc: parseInt(ok / count * 100, 10)
        badPerc: parseInt(bad / count * 100, 10)
      })

  add: (stat, callback) ->
    debug('add', stat)
    stat.createDate = new Date()
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

