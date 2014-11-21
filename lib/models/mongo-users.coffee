debug = require('debug')('vocabulary:mongo-users')

class MongoUsers
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

  findByOpenId: (openId, callback) ->
    @users.findOne {openId: openId}, (err, user) ->
      callback(err, user)

  reset: (callback) ->
    users = @users;
    seed = @seed;
    users.drop (err, data) ->
      users.insert seed, (err, data) ->
        callback(err)

module.exports = MongoUsers
