debug = require("debug")("vocabulary:server")
express = require("express")
path = require("path")
util = require("util")
_ = require("lodash")
logger = require("morgan")
cookieParser = require("cookie-parser")
cookieSession = require("cookie-session")
bodyParser = require("body-parser")
compression = require('compression')

passport = require('passport')
GoogleStrategy = require('passport-google-oauth').OAuth2Strategy

mongoskin = require('mongoskin')
wordlistRouter = require('./routes/wordlist-router')
statsRouter = require('./routes/stats-router')
MongoWordlists = require('./models/mongo-wordlists')
MongoUsers = require('./models/mongo-users')
MongoStats = require('./models/mongo-stats')

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
stats = new MongoStats(db)

app.set('view engine', 'ejs')
app.use compression()
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
  users.findByExternalId identifier, (err, user) ->
      done(err, user)

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

renderIndex = (req, resp) ->
  debug('user', req.user)
  resp.render('index', {
    isDevelopment: isDevelopment()
    user: util.inspect(_.omit(req.user, ['_id', 'createDate']))
  })
 
app.get "/", renderIndex
app.get "/wordlists/*", renderIndex
app.get "/wordform/*", renderIndex
app.get "/quiz/*", renderIndex

app.get "/status", (req, resp) ->
  debug "Status requested"
  resp.send "To be or not to be, that is the question"


app.use "/api/wordlists", wordlistRouter(wordlists)
app.use "/api/stats", statsRouter(stats)


module.exports = app
