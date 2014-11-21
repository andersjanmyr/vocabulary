debug = require('debug')('vocabulary:mongo-user')

class MongoUser
  constructor: (@db, @seed) ->
    @users = db.collection('users')

  findOrCreate: (user, callback) ->
    @users.findAndModify(
      {openId: user.openId },
      null,
      {$set: user},
      { new: true, upsert: true },
      callback
    )

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
