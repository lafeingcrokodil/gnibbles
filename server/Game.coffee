_     = require 'lodash'
debug = require('debug')('game')

keyCodes = require './keyCodes'
Level    = require './Level'

class Game

  players: []

  initialLength: 5
  delay: 50 # number of milliseconds between moves

  constructor: (@io) ->
    @level = new Level
    @io.on 'connection', (socket) =>
      socket.on 'join', (name) => @addPlayer name, socket
    @timer = setInterval @moveAll, @delay

  addPlayer: (name, socket) =>
    unless _.findWhere(@players, { name })
      debug "#{name} joined."
      newPlayer = { name, socket, segments: [] }
      @occupy newPlayer
      [row, col] = newPlayer.segments[0]
      while newPlayer.segments.length < @initialLength
        newPlayer.segments.push [row, col]
      @players.push newPlayer
      socket.emit 'level', @level.getSnapshot()
      socket.on 'key', @onKey(newPlayer)
      socket.on 'disconnect', => @removePlayer name
    else
      socket.emit 'error', { code: 'ER_DUPLICATE_NAME' }

  removePlayer: (name) =>
    debug "#{name} left."
    [player] = _.remove @players, 'name', name
    @unoccupy player.segments if player

  onKey: (player) => (keyCode) =>
    switch keyCode
      when keyCodes.LEFT_ARROW
        @changeDirection player, 'LEFT'
      when keyCodes.RIGHT_ARROW
        @changeDirection player, 'RIGHT'
      when keyCodes.UP_ARROW
        @changeDirection player, 'UP'
      when keyCodes.DOWN_ARROW
        @changeDirection player, 'DOWN'

  changeDirection: (player, newDirection) =>
    switch player.direction
      when 'LEFT', 'RIGHT'
        player.direction = newDirection if newDirection in ['UP', 'DOWN']
      when 'UP', 'DOWN'
        player.direction = newDirection if newDirection in ['LEFT', 'RIGHT']
      else
        player.direction = newDirection

  moveAll: =>
    @move player for player in @players

  move: (player) =>
    return unless player.direction
    [oldRow, oldCol] = oldPos = player.segments[0]
    newPos = switch player.direction
      when 'LEFT'  then { row: oldRow, col: oldCol - 1 }
      when 'RIGHT' then { row: oldRow, col: oldCol + 1 }
      when 'UP'    then { row: oldRow - 1, col: oldCol }
      when 'DOWN'  then { row: oldRow + 1, col: oldCol }
    lastPos = player.segments.pop()
    @occupy player, newPos.row, newPos.col
    @unoccupy [lastPos] unless lastPos is _.last player.segments

  occupy: (occupant, row, col) =>
    { char, row, col } = @level.occupy occupant, row, col
    occupant.segments.unshift [row, col]
    @io.emit 'display', { char, row, col }

  unoccupy: (positions) =>
    for position in positions
      [row, col] = position
      { char } = @level.unoccupy row, col
      @io.emit 'display', { char, row, col }

module.exports = Game
