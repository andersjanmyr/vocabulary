debug = require('debug')('vocabulary:mongo-user')

class MongoUser
  constructor: (@db, @seed) ->
    @users = db.collection('users')

  findOrCreate: (user, callback) ->
    @users.findAndModify({
      query: {openId: user.openId },
      update: {
        $setOnInsert: { openId: user.openId, displayName: user.displayName, email: user.email }
      },
      new: true
      upsert: true
    })

  findById: (id, callback) ->
    @users.findOne {_id: id}, (err, wordlist) ->
      callback(err, wordlist)

  reset: (callback) ->
    users = @users;
    seed = @seed;
    users.drop (err, data) ->
      users.insert seed, (err, data) ->
        callback(err)

module.exports = MongoUser
