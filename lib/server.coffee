express = require("express")
http = require("http")
path = require("path")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
debug = require("debug")("vocabulary:server")
wordlists = require('./word-lists')
livereload = require('express-livereload')

app = express()

isDevelopment = ->
  process.env.NODE_ENV is 'development'
livereload(app, config={}) if isDevelopment()

app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use express.static(path.join(__dirname, '..', "static"))
app.get "/status", (req, resp) ->
  debug "Status requested"
  resp.send "To be or not to be, that is the question"

app.use "/wordlists", wordlists


module.exports = app
