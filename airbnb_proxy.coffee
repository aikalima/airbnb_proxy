# Module dependencies.
express = require 'express'
url = require 'url'
nconf = require 'nconf'
https = require "https"
querystring = require 'querystring';
cheerio = require 'cheerio'
_ = require 'underscore'
require 'sugar' # extends prototypes globally

Listing = require './lib/Listing.js'
User = require './lib/User.js'
SearchResult = require './lib/SearchResult.js'

query_defaults =
  checkin: Date.create('tomorrow')
  guests: 2
  resultCount:25

AirbnbDate =
  create: (mmddyyyy) ->
    year = mmddyyyy.substring 4,8
    mm = mmddyyyy.substring 0,2
    dd = mmddyyyy.substring 2,4
    new Date('' + year + '-' + mm + '-' + dd)

app = module.exports = express()

###############
## SETUP  #####
###############
app.configure ->
  # read in environment or command-line arguments first
  #  - priority is given to the first entry found, i.e. args > env > environment.config > config
  # environment options can be set like this:
  #   set/export proxy:port=12345
  #
  # argument options can be set like this:
  #  node app.js --proxy:port=12345
  #
  # express.settings -> env Environment mode, defaults to process.env.NODE_ENV or "development"
  # set/export NODE_ENV=qa for QA
  # set/export NODE_ENV=production for production

  nconf.argv().env()
  nconf.add 'default-file', {type: 'file', file: "config.json"}

  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session
    secret: "supersecretvalue"

  app.use app.router
  app.use express.static(__dirname + '/app')

  if app.settings.env == 'development' || app.settings.env == 'qa'
    app.use express.errorHandler
      dumpExceptions: true
      showStack: true
  else
    app.use express.errorHandler()

  app.options =
    host: nconf.get "airbnb:host"
    port: nconf.get "airbnb:port"
    headers:
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.13 (KHTML, like Gecko) Chrome/24.0.1290.1 Safari/537.13'

port = nconf.get "proxy:port"
if port? && _.isString port then port = parseInt port, 10

app.listen port || 4000, ->
  console.log "Airbnb proxy server version 0.8 listening at http://localhost:#{port}"
  console.log "Airbnb: " +  nconf.get("airbnb:host") + " port:" + nconf.get("airbnb:port")

###############
## API  #######
###############

app.get '/user/:id', (req, res) ->
  userId = req.params.id
  app.options.path = '/users/show/'+userId
  app.fetch User, app.options, (result) -> _process(res, result)

app.get '/listing/:id', (req, res) ->
  hostingId = req.params.id
  app.options.path = '/rooms/'+hostingId
  app.fetch Listing, app.options, (result) -> _process(res, result)

app.get '/search/:location', (req, res) ->
  req.params.checkin = query_defaults.checkin.format '{MM}{dd}{yyyy}'
  req.params.checkout = query_defaults.checkin.addDays(1).format '{MM}{dd}{yyyy}'
  req.params.guests = query_defaults.guests
  app.run_search req,res

app.get '/search/:location/:checkin', (req, res) ->
  checkinDate = AirbnbDate.create req.params.checkin
  checkoutDate = checkinDate.addDays(1)
  req.params.checkout = checkoutDate.format '{MM}{dd}{yyyy}'
  app.run_search req,res

app.get '/search/:location/:checkin/:checkout', (req, res) ->
  app.run_search req,res

###############
## Processing #
###############
app.run_search = (req, res) ->
  location = req.params.location.replace ' ','-' #airbnb search uses '-' for white space
  checkin = req.params.checkin
  checkout = req.params.checkout
  qString = querystring.parse (url.parse req.url).query
  guests = qString.guests
  guests = query_defaults.guests unless guests?
  count = qString.resultCount
  count = query_defaults.resultCount unless count?

  app.options.path = '/s/'+location+'?checkin='+checkin+'&checkout='+checkout+'&guests='+guests+'&per_page='+count
  app.fetch SearchResult, app.options, (result) -> app.process(res, result)

app.fetch = (entity, options, callback) ->
  req = https.get options, (res) ->
    body = ''
    res.on 'data', (chunk) -> body += chunk
    res.on 'end', () ->
      callback entity.init cheerio, body

  req.on 'error', (err) ->
    console.log('Airbnb getPage -> error: %s', err)
    callback null

app.process = (res, result) ->
  if result?
    res.send(JSON.stringify result, 200)
  else
    res.send(JSON.stringify {'error'}, 200)