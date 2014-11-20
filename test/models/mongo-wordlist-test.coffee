expect = require('chai').expect
sinon = require('sinon')
mongoskin = require('mongoskin')

Wordlist = require('../../lib/models/mongo-wordlist');

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

wordlist = new Wordlist(db, seed);

describe 'mongo-wordlist', ->

  before (done) ->
    wordlist.reset(done)

  describe '#find', ->
    it 'finds the matching wordlists', (done) ->
      wordlist.find 'list', (err, wordlists) ->
        expect(wordlists.length).to.equal(3)
        expect(wordlists[0].name).to.match(/list/)
        done()


  describe '#add', ->
    original = null

    before (done) ->
      wordlist.find null, (err, wordlists) ->
        original = wordlists
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
      wordlist.add newlist, (err, id) ->
        wordlist.find null, (err, wordlists) ->
          expect(wordlists.length).to.equal(len + 1)
          done()


  describe '#remove', ->
    original = null
    awordlist = null

    before (done) ->
      wordlist.find null, (err, wordlists) ->
        original = wordlists
        awordlist = wordlists[0]
        done()

    it 'removes the wordlist by id', (done) ->
      len = original.length
      wordlist.remove awordlist._id, (err) ->
        wordlist.find null, (err, wordlists) ->
          expect(wordlists.length).to.equal(len - 1)
          done()

    it 'removes the wordlist by wordlist', (done) ->
      len = original.length
      wordlist.remove awordlist, (err) ->
      wordlist.find null, (err, wordlists) ->
        expect(wordlists.length).to.equal(len - 1)
        done()

    it 'calls back with error if wordlist missing', (done) ->
      wordlist.remove {_id: 'missing'}, (err) ->
        expect(err).to.equal('wordlist not found, id: missing')
        done()

  describe '#update', ->
    original = null
    awordlist = null

    before (done) ->
      wordlist.find null, (err, wordlists) ->
        original = wordlists
        awordlist = wordlists[0]
        done();

    it 'calls back with error if wordlist missing', (done) ->
      wordlist.update {_id: 'missing'}, (err) ->
        expect(err).to.equal('wordlist not found, id: missing')
        done()

    it 'updates the wordlist', (done) ->
      len = original.length
      wordlist.update {_id: awordlist._id, name: 'Vocabulary rules!'}, (err) ->
        wordlist.findById awordlist._id, (err, wordlist) ->
          expect(wordlist.name).to.equal('Vocabulary rules!')
          done()



