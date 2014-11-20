debug = require("debug")("vocabulary:server")
express = require("express")
path = require("path")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
mongoskin = require('mongoskin')
MongoWordlist = require('./models/mongo-wordlist')
wordlistRoute = require('./routes/wordlist-route')

app = express()

staticDir = path.join(__dirname, '..', 'static')

isDevelopment = ->
  process.env.NODE_ENV is 'development'

if isDevelopment()
  livereload = require('livereload')
  server = livereload.createServer()
  server.watch(staticDir)

dbUrl = process.env['MONGOHQ_URL'] or 'mongodb://@localhost:27017/vocabulary-dev'
console.log("Connecting to Mongo: #{dbUrl}")

db = mongoskin.db(dbUrl, {safe:true})
wordlist = new MongoWordlist(db)

app.set('view engine', 'ejs')
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})
app.use cookieParser()
app.use express.static(staticDir)
app.get "/", (req, resp) ->
  resp.render('index', {isDevelopment: isDevelopment()})
app.get "/status", (req, resp) ->
  debug "Status requested"
  resp.send "To be or not to be, that is the question"

app.use "/wordlists", wordlistRoute(wordlist)


module.exports = app
