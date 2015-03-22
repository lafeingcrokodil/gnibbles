_     = require 'lodash'
debug = require('debug')('game')

Level = require './Level'

class Game

  players: []

  constructor: (@io) ->
    @level = new Level
    @io.on 'connection', (socket) =>
      socket.on 'join', (name) => @addPlayer name, socket

  addPlayer: (name, socket) =>
    unless _.findWhere(@players, { name })
      debug "#{name} joined."
      newPlayer = { name, socket, segments: [] }
      @occupy newPlayer
      @players.push newPlayer
      socket.emit 'level', @level.getSnapshot()
      socket.on 'disconnect', => @removePlayer name
    else
      socket.emit 'error', { code: 'ER_DUPLICATE_NAME' }
  
  removePlayer: (name) =>
    debug "#{name} left."
    [player] = _.remove @players, 'name', name
    @unoccupy player.segments if player

  occupy: (occupant, row, col) =>
    { char, row, col } = @level.occupy occupant, row, col
    @io.emit 'display', { char, row, col }

  unoccupy: (positions) =>
    for position in positions
      [row, col] = position
      { char } = @level.unoccupy row, col
      @io.emit 'display', { char, row, col }

module.exports = Game
