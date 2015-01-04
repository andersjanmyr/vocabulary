expect = require('chai').expect
sinon = require('sinon')
mongoskin = require('mongoskin')

Stats = require('../../lib/models/mongo-stats');

db = mongoskin.db('mongodb://@localhost:27017/vocabulary-test', {safe:true});

# Example lists
seed = [
  {
    "quiz":"54a8f6152564a00000fc2ee4",
    "words":1,
    "tries":1,
    "wrong":0,
    "wrongCase":0,
    "correct":1,
    "elapsedTime":4.238,
    "user":'dingo',
    "createDate":"2015-01-04T10:10:22.900Z"
  },
  {
    "quiz":"7878473829784937",
    "words":1,
    "tries":1,
    "wrong":0,
    "wrongCase":0,
    "correct":1,
    "elapsedTime":3.459,
    "user":'dingo',
    "createDate":"2015-01-04T10:57:52.064Z"
  },
  {
    "quiz":"7878473829784937",
    "words":3,
    "tries":5,
    "wrong":0,
    "wrongCase":0,
    "correct":1,
    "elapsedTime":3.459,
    "user":'dingo',
    "createDate":"2015-01-04T10:57:52.064Z"
  },
  {
    "quiz":"7878473829784937",
    "words":3,
    "tries":4,
    "wrong":0,
    "wrongCase":0,
    "correct":1,
    "elapsedTime":3.459,
    "user":'dingo',
    "createDate":"2015-01-04T10:57:52.064Z"
  }

]

stats = new Stats(db, seed);

describe 'mongo-stats', ->

  before (done) ->
    stats.reset(done)

  describe '#byUser', ->
    it 'finds an existing user', (done) ->
      stats.byUser 'dingo', (err, result) ->
        console.log(result)
        expect(result.count).to.equal(4)
        expect(result.perfect).to.equal(2)
        expect(result.ok).to.equal(1)
        expect(result.bad).to.equal(1)
        expect(result.perfectPerc).to.equal(50)
        expect(result.okPerc).to.equal(25)
        expect(result.badPerc).to.equal(25)
        done()





