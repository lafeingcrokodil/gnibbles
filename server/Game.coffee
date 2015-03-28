_     = require 'lodash'
debug = require('debug')('game')

keyCodes = require './keyCodes'
Level    = require './Level'

class Game

  players: []

  initialLength: 5
  delay:
    move    : 50   # number of milliseconds between moves
    respawn : 3000 # number of milliseconds until player respawns

  constructor: (@io) ->
    @level = new Level
    do @spawnFrog
    @io.on 'connection', (socket) =>
      socket.on 'join', (name) => @addPlayer name, socket
    @timer = setInterval @moveAll, @delay.move

  spawnFrog: =>
    frog = { type: 'FROG' }
    { char, row, col } = @level.occupy frog, row, col
    @io.emit 'display', { char, row, col }

  addPlayer: (name, socket) =>
    unless _.findWhere(@players, { name })
      debug "#{name} joined."
      newPlayer = { name, type: 'PLAYER', socket, segments: [] }
      @occupy newPlayer
      { row, col } = newPlayer.segments[0]
      while newPlayer.segments.length < @initialLength
        newPlayer.segments.push { row, col }
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
    return unless player.segments.length
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
    return unless player.direction and player.segments.length
    { row: oldRow, col: oldCol } = oldPos = player.segments[0]
    theoreticalPos = switch player.direction
      when 'LEFT'  then { row: oldRow, col: oldCol - 1 }
      when 'RIGHT' then { row: oldRow, col: oldCol + 1 }
      when 'UP'    then { row: oldRow - 1, col: oldCol }
      when 'DOWN'  then { row: oldRow + 1, col: oldCol }
    newPos = @level.getActualPos theoreticalPos
    if @level.isWall newPos
      @reset player
    else if @level.getOccupant newPos
      occupant = @level.getOccupant newPos
      if occupant.type is 'FROG'
        @unoccupy [newPos]
        { row, col } = _.last player.segments
        for i in [1..3]
          player.segments.push { row, col }
        do @spawnFrog
      else
        @handleCollision player, occupant, newPos
    else
      lastPos = player.segments.pop()
      @occupy player, newPos.row, newPos.col
      @unoccupy [lastPos] unless lastPos is _.last player.segments

  handleCollision: (player, occupant, newPos) =>
    if occupant.name isnt player.name
      { row: occupantRow, col: occupantCol } = occupant.segments[0]
      if occupantRow is newPos.row and occupantCol is newPos.col
        @reset player
        @reset occupant
      else
        @reset player
    else
      { row: occupantRow, col: occupantCol } = occupant.segments[1]
      unless occupantRow is newPos.row and occupantCol is newPos.col
        @reset player

  reset: (player) =>
    @unoccupy player.segments
    player.segments = []
    player.direction = null
    setTimeout @respawn(player), @delay.respawn

  respawn: (player) => =>
    @occupy player
    { row, col } = player.segments[0]
    while player.segments.length < @initialLength
      player.segments.push { row, col }

  occupy: (occupant, row, col) =>
    { char, row, col } = @level.occupy occupant, row, col
    occupant.segments.unshift { row, col }
    @io.emit 'display', { char, row, col }

  unoccupy: (positions) =>
    for position in positions
      { row, col } = position
      { char } = @level.unoccupy row, col
      @io.emit 'display', { char, row, col }

module.exports = Game
