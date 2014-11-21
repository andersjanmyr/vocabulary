expect = require('chai').expect
sinon = require('sinon')
mongoskin = require('mongoskin')

Users = require('../../lib/models/mongo-users');

db = mongoskin.db('mongodb://@localhost:27017/vocabulary-test', {safe:true});

# Example lists
seed =
  {
    openId: 'https://and.id.com',
    displayName: 'Tapir',
    email: 'tapir@janmyr.com'
  }

users = new Users(db, seed);

describe 'mongo-users', ->

  before (done) ->
    users.reset(done)

  describe '#findOrCreate', ->
    it 'creates a new user', (done) ->
      newUser = { openId: 'oid', displayName: 'Oid', email: 'oid@oid.com' }
      users.findOrCreate newUser, (err, user) ->
        expect(user.displayName).to.equal(newUser.displayName)
        expect(user.email).to.equal(newUser.email)
        done()

  describe '#findByOpenId', ->
    it 'finds an existing user', (done) ->
      users.findByOpenId seed.openId, (err, user) ->
        console.log('user', user)
        expect(user.displayName).to.equal('Tapir')
        expect(user.email).to.equal('tapir@janmyr.com')
        done()




