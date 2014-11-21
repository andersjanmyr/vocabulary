express = require('express')
router = express.Router()

router.get '/', (req, res) ->
  wordlist.find req.query.filter, (err, wordlists) ->
    return res.status(500).send(err) if err
    res.send(wordlists)

router.get '/:id', (req, res) ->
  wordlist.findById req.params.id, (err, wordlist) ->
    return res.status(404).send(err) if err
    res.send(wordlist)

router.post '/', (req, res) ->
  wordlist.add req.body, (err, id) ->
    return res.status(500).send(err) if err
    console.log('id', id)
    res.status(201).send(id)

router.put '/:id', (req, res) ->
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




