debug = require("debug")("vocabulary:server")
express = require("express")
path = require("path")
logger = require("morgan")
cookieParser = require("cookie-parser")
cookieSession = require("cookie-session")
bodyParser = require("body-parser")

passport = require('passport')
GoogleStrategy = require('passport-google').Strategy

mongoskin = require('mongoskin')
wordlistRoute = require('./routes/wordlist-route')
MongoWordlist = require('./models/mongo-wordlist')
MongoUser = require('./models/mongo-user')

app = express()

staticDir = path.join(__dirname, '..', 'static')

isDevelopment = ->
  process.env.NODE_ENV is 'development'


authConfig = {
  returnURL: 'http://vocabulary.janmyr.com/auth/google/return'
  realm: 'http://vocabulary.janmyr.com/'
  stateless: true
}

if isDevelopment()
  livereload = require('livereload')
  server = livereload.createServer()
  server.watch(staticDir)
  authConfig = {
    returnURL: 'http://localhost:3000/auth/google/return'
    realm: 'http://localhost:3000/'
    stateless: true
  }

dbUrl = process.env['MONGOHQ_URL'] or 'mongodb://@localhost:27017/vocabulary-dev'
console.log("Connecting to Mongo: #{dbUrl}")

db = mongoskin.db(dbUrl, {safe:true})
wordlist = new MongoWordlist(db)
users = new MongoUser(db)

app.set('view engine', 'ejs')
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})
app.use cookieParser()
app.use cookieSession({secret: 'tapir'})
app.use express.static(staticDir)
app.use passport.initialize()
app.use passport.session()

strategy = new GoogleStrategy(authConfig, (identifier, profile, done) ->
  debug('Logged in', identifier, profile)
  user = {openId: identifier, displayName: profile.displayName, email: profile.emails[0].value}
  #users.findOrCreate user, ->
  done(null, user))

passport.serializeUser (user, done) ->
  debug('serializeUser', user)
  done(null, user.openId)

passport.deserializeUser (identifier, done) ->
  debug('deserializeUser', identifier)
  done(null, { openId: identifier})

passport.use(strategy)

app.get('/auth/google', passport.authenticate('google'))

app.get('/auth/google/return',
  passport.authenticate('google', {successRedirect: '/', failureRedirect: '/login'}))

app.get "/", (req, resp) ->
  console.log('user', req.user)
  resp.render('index', {
    isDevelopment: isDevelopment()
    user: req.user
  })
app.get "/status", (req, resp) ->
  debug "Status requested"
  resp.send "To be or not to be, that is the question"

app.use "/wordlists", wordlistRoute(wordlist)


module.exports = app
