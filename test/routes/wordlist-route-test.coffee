request = require('supertest')
expect = require('chai').expect
sinon = require('sinon')
express = require('express')
bodyParser = require('body-parser')

wordlistRouter = require('../../lib/routes/wordlist-router.coffee')

app = express()
app.use(bodyParser.json())
wordlists = {
  find: sinon.mock().withArgs('fooled').yields(null, [{name: 'something'}])
  findById: sinon.mock().withArgs('geb').yields(null, {name: 'In London on vacation'})
  add: sinon.mock().withArgs({name: 'newlist', owner: 'dingo'}).yields(null, 'ilv')
  update: sinon.mock().withArgs({id: 'fbr', name: 'Fakewordlist rocks!', owner: 'dingo'}).yields(null, {name: 'Fakewordlist'})
  remove: sinon.mock().withArgs('fbr').yields(null, {name: 'Fakewordlist'})
}

authenticatedUser = null

app.use (req, res, next) ->
  req.user = authenticatedUser
  next()

app.use('/wordlists', wordlistRouter(wordlists))

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
  it 'adds the new wordlist with correct user', (done) ->
    authenticatedUser = { email: 'dingo' }
    request(app)
      .post('/wordlists')
      .send({name: 'newlist', owner: 'dingo'})
      .end (err, res) ->
        authenticatedUser = null
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.body).to.equal('ilv')
        done()

  it 'responds with error with no user', (done) ->
    authenticatedUser = null
    request(app)
      .post('/wordlists')
      .send({name: 'newlist', owner: 'dingo'})
      .end (err, res) ->
        authenticatedUser = null
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.status).to.equal(403)
        done()

  it 'responds with error for invalid user and owner', (done) ->
    authenticatedUser = { email: 'tapir' }
    request(app)
      .post('/wordlists')
      .send({name: 'newlist', owner: 'dingo'})
      .end (err, res) ->
        authenticatedUser = null
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.status).to.equal(403)
        done()

describe 'PUT /wordlists/fbr', () ->
  it 'responds with matching wordlist for valid user', (done) ->
    authenticatedUser = { email: 'dingo' }
    request(app)
      .put('/wordlists/fbr')
      .send({name: 'Fakewordlist rocks!', owner: 'dingo'})
      .end (err, res) ->
        authenticatedUser = null
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.body.name).to.match(/Fakewordlist/)
        done()

  it 'responds with error for invalid user', (done) ->
    authenticatedUser = { email: 'tapir' }
    request(app)
      .put('/wordlists/fbr')
      .send({name: 'Fakewordlist rocks!', owner: 'dingo'})
      .end (err, res) ->
        authenticatedUser = null
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.status).to.equal(403)
        done()

  it 'responds with error for no user', (done) ->
    authenticatedUser = null
    request(app)
      .put('/wordlists/fbr')
      .send({name: 'Fakewordlist rocks!'})
      .end (err, res) ->
        throw err if err
        expect(res.get('content-type')).to.match(/json/)
        expect(res.status).to.equal(403)
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

