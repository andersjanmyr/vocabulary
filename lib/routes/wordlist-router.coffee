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

verifyUserIsOwner = (req, resource) ->
  user = req.user and req.user.email
  debug 'currentUserIsOwner', user
  if not user or user isnt resource.owner
    return {
      error: 'Resource is not owned by by current user'
      currentUser: user
      owner: resource.owner
    }
  return {error: false}

router.post '/', (req, res) ->
  result = verifyUserIsOwner(req, req.body)
  return res.status(403).send(result) if result.error

  wordlist.add req.body, (err, id) ->
    return res.status(409).send(err) if err
    console.log('id', id)
    res.status(201).json(id)

router.put '/:id', (req, res) ->
  result = verifyUserIsOwner(req, req.body)
  return res.status(403).send(result) if result.error
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




