express = require('express')
router = express.Router()
debug = require('debug')('vocabulary:wordlistRouter')

router.get '/', (req, res) ->
  wordlist.find req.query.filter, (err, wordlists) ->
    return res.status(500).send(err) if err
    res.send(wordlists)

router.get '/:id', (req, res) ->
  wordlist.findById req.params.id, (err, wordlist) ->
    return res.status(404).send(err) if err
    res.send(wordlist)

router.post '/', (req, res) ->
  user = req.user and req.user.email
  debug 'user', user
  if not user
    return res.status(403).json('Not logged in')
  if user isnt req.body.owner
    return res.status(403).json('Cannot create resource for another user')
  wordlist.add req.body, (err, id) ->
    return res.status(409).send(err) if err
    console.log('id', id)
    res.status(201).json(id)

router.put '/:id', (req, res) ->
  user = req.user and req.user.email
  debug 'user', user
  if not user
    return res.status(403).json('Not logged in')
  if user isnt req.body.owner
    return res.status(403).json('Cannot create resource for another user')
  req.body.id = req.param('id')
  wordlist.update req.body, (err, wordlist) ->
    return res.status(404).send(err) if err
    res.send(wordlist)

router.delete '/:id', (req, res) ->
    wordlist.remove req.param('id'), (err, wordlist) ->
      return res.status(404).send(err) if err
      res.send(wordlist)

wordlist = null
wordlistsRouter = (wordlistModel) ->
  wordlist = wordlistModel
  router

module.exports = wordlistsRouter




