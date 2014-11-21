expect = require('chai').expect
sinon = require('sinon')
mongoskin = require('mongoskin')

User = require('../../lib/models/mongo-user');

db = mongoskin.db('mongodb://@localhost:27017/vocabulary-test', {safe:true});

# Example lists
seed =
  {
    openId: 'https://and.id.com',
    displayName: 'Tapir',
    email: 'tapir@janmyr.com'
  }

users = new User(db, seed);

describe 'mongo-user', ->

  before (done) ->
    users.reset(done)

  describe '#findOrCreate', ->
    it 'creates a new user', (done) ->
      users.findOrCreate seed, (err, user) ->
        console.log('user', user)
        expect(user.displayName).to.equal('Tapir')
        expect(user.email).to.equal('tapir@janmyr.com')
        done()





