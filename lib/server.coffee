debug = require("debug")("vocabulary:server")
express = require("express")
path = require("path")
util = require("util")
_ = require("lodash")
logger = require("morgan")
cookieParser = require("cookie-parser")
cookieSession = require("cookie-session")
bodyParser = require("body-parser")

passport = require('passport')
GoogleStrategy = require('passport-google-oauth').OAuth2Strategy

mongoskin = require('mongoskin')
wordlistRoute = require('./routes/wordlist-route')
MongoWordlists = require('./models/mongo-wordlists')
MongoUsers = require('./models/mongo-users')

app = express()

staticDir = path.join(__dirname, '..', 'static')

isDevelopment = ->
  process.env.NODE_ENV is 'development'


authConfig = {
  clientID: '410656465057-aa81snbalq1pmr2fcl4jd0tce86j8k3q.apps.googleusercontent.com'
  clientSecret: 'cjF0i7H6bLiXQ2cxjpD9nu77'
  callbackURL: "http://vocabulary.janmyr.com/auth/google/callback"
}

if isDevelopment()
  livereload = require('livereload')
  server = livereload.createServer()
  server.watch(staticDir)
  authConfig = {
    clientID: '410656465057-61m92gbq68a189b89tub32p4r2orb362.apps.googleusercontent.com'
    clientSecret: 'KoLwzX7auJIPznHYAJvIiwNt'
    callbackURL: "http://localhost:3000/auth/google/callback"
  }

dbUrl = process.env['MONGOHQ_URL'] or 'mongodb://@localhost:27017/vocabulary-dev'
console.log("Connecting to Mongo: #{dbUrl}")

db = mongoskin.db(dbUrl, {safe:true})
wordlists = new MongoWordlists(db)
users = new MongoUsers(db)

app.set('view engine', 'ejs')
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded({extended: true})
app.use cookieParser()
app.use cookieSession({secret: 'tapir'})
app.use express.static(staticDir)
app.use passport.initialize()
app.use passport.session()

strategy = new GoogleStrategy(authConfig,
  (accessToken, refreshToken, profile, done) ->
    debug('Logged in', accessToken, refreshToken, profile)
    user = {
      provider: profile.provider
      externalId: profile.id
      displayName: profile.displayName
      email: profile.emails[0].value
      picture: profile._json.picture
    }
    users.findOrCreate user, (err, user) ->
      debug('findOrCreate', user)
      done(null, user))

passport.serializeUser (user, done) ->
  debug('serializeUser', user)
  done(null, user.externalId)

passport.deserializeUser (identifier, done) ->
  debug('deserializeUser', identifier)
  done(null, { externalId: identifier})

passport.use(strategy)

app.get('/auth/google', passport.authenticate('google', {
  scope:
    ['https://www.googleapis.com/auth/userinfo.profile'
    'https://www.googleapis.com/auth/userinfo.email']
  }
))

app.get('/auth/google/callback',
  passport.authenticate('google', {successRedirect: '/', failureRedirect: '/login'}))

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect('/')

app.get "/", (req, resp) ->
  debug('user', req.user)
  externalId = req.user && req.user.externalId
  users.findByExternalId externalId, (err, user) ->
    debug('findByExternalId', err, user)
    resp.render('index', {
      isDevelopment: isDevelopment()
      user: util.inspect(_.omit(user, '_id'))
    })

app.get "/status", (req, resp) ->
  debug "Status requested"
  resp.send "To be or not to be, that is the question"

app.use "/wordlists", wordlistRoute(wordlists)


module.exports = app
