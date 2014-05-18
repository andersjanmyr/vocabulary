"use strict"
express = require("express")
wordlists = express.Router()
wordlists.get "/", (req, res) ->
  res.send JSON.stringify([1, 2, 3])

module.exports = wordlists
