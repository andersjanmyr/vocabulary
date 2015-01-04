express = require('express')
router = express.Router()

router.get '/', (req, res) ->
  statistics.find req.query.filter, (err, stats) ->
    return res.status(500).send(err) if err
    res.send(stats)

router.post '/', (req, res) ->
  stats = req.body
  stats.user = req.user and req.user.email
  statistics.add stats, (err, id) ->
    return res.status(409).send(err) if err
    console.log('id', id)
    res.status(201).json(id)

router.get '/:email', (req, res) ->
  statistics.byUser req.params.email, (err, stats) ->
    return res.status(500).send(err) if err
    res.send(stats)

statistics = null
statsRouter = (statsModel) ->
  statistics = statsModel
  router

module.exports = statsRouter




