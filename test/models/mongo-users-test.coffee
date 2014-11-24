expect = require('chai').expect
sinon = require('sinon')
mongoskin = require('mongoskin')

Users = require('../../lib/models/mongo-users');

db = mongoskin.db('mongodb://@localhost:27017/vocabulary-test', {safe:true});

# Example lists
seed =
  {
    provider: 'google'
    externalId: 'https://and.id.com'
    displayName: 'Tapir'
    email: 'tapir@janmyr.com'
    picture: 'http://fc09.deviantart.net/fs41/f/2009/030/2/7/tapir_avatar_by_gescheitert.png'
  }

users = new Users(db, seed);

describe 'mongo-users', ->

  before (done) ->
    users.reset(done)

  describe '#findOrCreate', ->
    it 'creates a new user', (done) ->
      newUser = { externalId: 'oid', displayName: 'Oid', email: 'oid@oid.com' }
      users.findOrCreate newUser, (err, user) ->
        expect(user.displayName).to.equal(newUser.displayName)
        expect(user.email).to.equal(newUser.email)
        done()

  describe '#findByExternalId', ->
    it 'finds an existing user', (done) ->
      users.findByExternalId seed.externalId, (err, user) ->
        expect(user.provider).to.equal('google')
        expect(user.displayName).to.equal('Tapir')
        expect(user.email).to.equal('tapir@janmyr.com')
        done()




