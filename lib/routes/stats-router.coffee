express = require('express')
router = express.Router()

router.get '/', (req, res) ->
  statistics.find req.query.filter, (err, stats) ->
    return res.status(500).send(err) if err
    res.send(stats)

router.post '/', (req, res) ->
  statistics.add req.body, (err, id) ->
    return res.status(409).send(err) if err
    console.log('id', id)
    res.status(201).json(id)


statistics = null
statsRouter = (statsModel) ->
  statistics = statsModel
  router

module.exports = statsRouter




