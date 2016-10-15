debug = require('debug')('vocabulary:mongo-users')

class MongoUsers
  constructor: (@db, @seed) ->
    @users = @db.collection('users')

  findOrCreate: (user, callback) ->
    user.createDate = new Date()
    @users.findAndModify(
      {externalId: user.externalId},
      null,
      {$set: user},
      { new: true, upsert: true },
      callback
    )

  findByExternalId: (externalId, callback) ->
    process.nextTick(callback.bind(null, 'Missing externalId')) unless externalId
    @users.findOne {externalId: externalId}, (err, user) ->
      callback(err, user)

  reset: (callback) ->
    users = @users;
    seed = @seed;
    users.drop (err, data) ->
      users.insert seed, (err, data) ->
        callback(err)

module.exports = MongoUsers
