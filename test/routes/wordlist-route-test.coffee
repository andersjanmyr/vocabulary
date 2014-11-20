request = require('supertest')
expect = require('chai').expect
sinon = require('sinon')
express = require('express')
bodyParser = require('body-parser')

wordlistRouter = require('../../lib/routes/wordlist-route.coffee')
WordList = require('../../lib/models/mongo-wordlist.coffee')

app = express()
app.use(bodyParser.json())
wordlist = {
  find: sinon.mock().withArgs('fooled').yields(null, [{name: 'something'}])
  findById: sinon.mock().withArgs('geb').yields(null, {name: 'In London on vacation'})
  add: sinon.mock().withArgs({name: 'newlist'}).yields(null, 'ilv')
  update: sinon.mock().withArgs({id: 'fbr', name: 'Fakewordlist rocks!'}).yields(null, {name: 'Fakewordlist'})
  remove: sinon.mock().withArgs('fbr').yields(null, {name: 'Fakewordlist'})
}

app.use('/wordlists', wordlistRouter(wordlist))

describe 'GET /wordlists?filter=fooled', () ->
  it 'responds with matching wordlists', (done) ->
    request(app)
      .get('/wordlists?filter=fooled')
      .end (err, res) ->
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.body.length).to.equal(1)
        expect(res.body.length).to.equal(1)
        done()

describe 'GET /wordlists/geb', ->
  it 'responds with matching wordlist', (done) ->
    request(app)
      .get('/wordlists/geb')
      .end (err, res) ->
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.body.name).to.match(/In London/)
        done()

describe 'POST /wordlists', ->
  it 'adds the new wordlist', (done) ->
    request(app)
      .post('/wordlists')
      .send({name: 'newlist'})
      .end (err, res) ->
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.body).to.equal('ilv')
        done()

describe 'PUT /wordlists/fbr', () ->
  it 'responds with matching wordlist', (done) ->
    request(app)
      .put('/wordlists/fbr')
      .send({name: 'Fakewordlist rocks!'})
      .end (err, res) ->
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.body.name).to.match(/Fakewordlist/)
        done()

describe 'DELETE /wordlists/fbr', ->
  it 'responds with matching wordlist', (done) ->
    request(app)
      .delete('/wordlists/fbr')
      .end (err, res) ->
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.body.name).to.match(/Fakewordlist/)
        done()

