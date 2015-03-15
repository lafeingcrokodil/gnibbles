var http  = require('http');
var debug = require('debug')('server');

require('coffee-script/register');

var app = require('../app');

var port = process.env.PORT || '3000';
app.set('port', port);

var server = http.createServer(app);

server.listen(port);

server.on('error', onError);
server.on('listening', onListening);

function onError(err) {
  if (err.syscall !== 'listen') throw err;

  switch (err.code) {
    case 'EACCES':
      console.error('Port ' + port + ' requires elevated privileges.');
      process.exit(1);
      break;
    case 'EADDRINUSE':
      console.error('Port ' + port + ' is already in use.');
      process.exit(1);
      break;
    default:
      throw err;
  }
}

function onListening() {
  debug('Listening on port ' + server.address().port + '.');
}
