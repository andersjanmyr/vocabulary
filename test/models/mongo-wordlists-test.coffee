expect = require('chai').expect
sinon = require('sinon')
mongoskin = require('mongoskin')

Wordlists = require('../../lib/models/mongo-wordlists');

db = mongoskin.db('mongodb://@localhost:27017/vocabulary-test', {safe:true});

# Example lists
seed = [
  {
    name: 'Pet list',
    lang1: 'Swedish',
    lang2: 'English',
    words: [
      [ 'fisk', 'fish'],
      [ 'katt', 'cat'],
      [ 'hund', 'dog']
    ]
  },
  {
    name: 'Animal list',
    lang1: 'Swedish',
    lang2: 'English',
    words: [
      [ 'tapir', 'tapir'],
      [ 'bältdjur', 'armadillo'],
      [ 'myrslok', 'anteater']
    ]
  },
  {
    name: 'Thing list',
    lang1: 'Swedish',
    lang2: 'English',
    words: [
      [ 'stol', 'chair'],
      [ 'bord', 'table'],
      [ 'soffa', 'sofa']
    ]
  }
]

wordlists = new Wordlists(db, seed);

describe 'mongo-wordlists', ->

  before (done) ->
    wordlists.reset(done)

  describe '#find', ->
    it 'finds the matching wordlists', (done) ->
      wordlists.find 'list', (err, lists) ->
        expect(lists.length).to.equal(3)
        expect(lists[0].name).to.match(/list/)
        done()


  describe '#add', ->
    original = null

    before (done) ->
      wordlists.find null, (err, lists) ->
        original = lists
        done()

    it 'adds the wordlist', (done) ->
      len = original.length
      newlist = {
        name: 'New list',
        lang1: 'Swedish',
        lang2: 'English',
        words: [
          [ 'stol', 'chair'],
          [ 'bord', 'table'],
          [ 'soffa', 'sofa']
        ]
      }
      wordlists.add newlist, (err, id) ->
        wordlists.find null, (err, lists) ->
          expect(lists.length).to.equal(len + 1)
          done()


  describe '#remove', ->
    original = null
    awordlist = null

    before (done) ->
      wordlists.find null, (err, lists) ->
        original = lists
        awordlist = lists[0]
        done()

    it 'removes the wordlist by id', (done) ->
      len = original.length
      wordlists.remove awordlist._id, (err) ->
        wordlists.find null, (err, lists) ->
          expect(lists.length).to.equal(len - 1)
          done()

    it 'removes the wordlist by wordlist', (done) ->
      len = original.length
      wordlists.remove awordlist, (err) ->
      wordlists.find null, (err, lists) ->
        expect(lists.length).to.equal(len - 1)
        done()

    it 'calls back with error if wordlist missing', (done) ->
      wordlists.remove {_id: 'missing'}, (err) ->
        expect(err).to.equal('wordlist not found, id: missing')
        done()

  describe '#update', ->
    original = null
    awordlist = null

    before (done) ->
      wordlists.find null, (err, lists) ->
        original = lists
        awordlist = lists[0]
        done();

    it 'calls back with error if wordlist missing', (done) ->
      wordlists.update {_id: 'missing'}, (err) ->
        expect(err).to.equal('wordlist not found, id: missing')
        done()

    it 'updates the wordlist', (done) ->
      len = original.length
      wordlists.update {_id: awordlist._id, name: 'Vocabulary rules!'}, (err) ->
        wordlists.findById awordlist._id, (err, list) ->
          expect(list.name).to.equal('Vocabulary rules!')
          done()



