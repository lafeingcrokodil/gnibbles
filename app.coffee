path         = require 'path'
express      = require 'express'
logger       = require 'morgan'
bodyParser   = require 'body-parser'
cookieParser = require 'cookie-parser'
favicon      = require 'serve-favicon'

routes = require './routes/index'

app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

# TODO place favicon in /public and uncomment the following line
#app.use favicon(path.join(__dirname, 'public', 'favicon.ico'))
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })
app.use cookieParser()
app.use require('node-compass')({ mode: 'expanded' })
app.use express.static(path.join(__dirname, 'public'))

app.use '/', routes

app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err

if app.get('env') is 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
      message : err.message
      error   : err

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message : err.message
    error   : {}

module.exports = app
