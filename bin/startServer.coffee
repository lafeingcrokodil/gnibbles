http     = require 'http'
debug    = require('debug')('server')
socketIO = require 'socket.io'

app = require '../app'

port = process.env.PORT || '3000'
app.set 'port', port

server = http.createServer app
io     = socketIO server

app.setIO io

server.listen port, ->
  debug "Listening on port #{server.address().port}."

server.on 'error', (err) ->
  throw err if err.syscall isnt 'listen'

  switch err.code
    when 'EACCES'
      console.error "Port #{port} requires elevated privileges."
      process.exit 1
    when 'EADDRINUSE'
      console.error "Port #{port} is already in use."
      process.exit 1
    else
      throw err
