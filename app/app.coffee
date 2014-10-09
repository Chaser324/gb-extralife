express = require 'express'
hbs = require 'express3-handlebars'

config = require './config'

oauth = require 'oauth'
sys = require 'util'

app = express()
port = 3700


app.set 'views', __dirname + '/views'
app.engine 'hbs', hbs
    defaultLayout: 'main'
app.set 'view engine', 'hbs'
app.use express.static __dirname + '/public'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use express.session
    secret: config.EXPRESS_SESSION_SECRET
app.use (req, res, next) ->
    res.locals.user = req.session.user
    next()








twitterConsumerKey = config.TWITTER_CONSUMER_KEY
twitterConsumerSecret = config.TWITTER_CONSUMER_SECRET
console.log "_twitterConsumerKey: %s and _twitterConsumerSecret %s", twitterConsumerKey, twitterConsumerSecret

consumer = ->
    return new oauth.OAuth 'https://api.twitter.com/oauth/request_token',
        'https://api.twitter.com/oauth/access_token',
         twitterConsumerKey,
         twitterConsumerSecret,
         "1.0A",
         'http://localhost:3700/sessions/callback',
         "HMAC-SHA1"

app.get '/sessions/connect', (req, res) ->
    consumer().getOAuthRequestToken (error, oauthToken, oauthTokenSecret, results) ->
        if error
            res.send "Error getting OAuth request token : " + sys.inspect(error), 500
        else
            sys.puts "results>>"+sys.inspect(results)
            sys.puts "oauthToken>>"+oauthToken
            sys.puts "oauthTokenSecret>>"+oauthTokenSecret

            req.session.oauthRequestToken = oauthToken
            req.session.oauthRequestTokenSecret = oauthTokenSecret
            res.redirect "https://api.twitter.com/oauth/authorize?oauth_token="+req.session.oauthRequestToken


app.get '/sessions/callback', (req, res) ->
    sys.puts "oauthRequestToken>>"+req.session.oauthRequestToken
    sys.puts "oauthRequestTokenSecret>>"+req.session.oauthRequestTokenSecret
    sys.puts "oauth_verifier>>"+req.query.oauth_verifier
    consumer().getOAuthAccessToken req.session.oauthRequestToken,
        req.session.oauthRequestTokenSecret,
        req.query.oauth_verifier,
        (error, oauthAccessToken, oauthAccessTokenSecret, results) ->
            if error
                res.send "Error getting OAuth access token : " + sys.inspect(error), 500
            else
                req.session.oauthAccessToken = oauthAccessToken
                req.session.oauthAccessTokenSecret = oauthAccessTokenSecret
                consumer().get "https://api.twitter.com/1.1/account/verify_credentials.json",
                    req.session.oauthAccessToken,
                    req.session.oauthAccessTokenSecret,
                    (error, data, response) ->
                        if error
                            res.send "Error getting twitter screen name : " + sys.inspect(error), 500
                        else
                            data = JSON.parse(data)
                            req.session.twitterScreenName = data["screen_name"]
                            req.session.twitterLocaltion = data["location"]
                            # res.send 'You are signed in with Twitter screenName ' + req.session.twitterScreenName + ' and twitter thinks you are in ' + req.session.twitterLocaltion









app.get "/chat", (req, res) ->
    res.render 'chat.hbs',
        layout: false

io = require('socket.io').listen app.listen port
io.sockets.on 'connection', (socket) ->
    socket.emit 'message', { message: 'welcome to the chat' }
    socket.on 'send', (data) ->
        io.sockets.emit 'message', data

console.log "Listening on port " + port
