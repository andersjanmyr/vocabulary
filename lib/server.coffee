express = require("express")
http = require("http")
path = require("path")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
debug = require("debug")("vocabulary:server")
wordlists = require('./word-lists')
livereload = require('livereload')

app = express()

staticDir = path.join(__dirname, '..', 'static')

isDevelopment = ->
  process.env.NODE_ENV is 'development'

if isDevelopment()
  server = livereload.createServer()
  server.watch(staticDir)

app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})
app.use cookieParser()
app.use express.static(staticDir)
app.get "/status", (req, resp) ->
  debug "Status requested"
  resp.send "To be or not to be, that is the question"

app.use "/wordlists", wordlists


module.exports = app
