_     = require 'lodash'
debug = require('debug')('game')

keyCodes = require './keyCodes'

Level  = require './Level'
Player = require './Player'
Frog   = require './Frog'

class Game

  frogsPerLevel : 1    # number of frogs required to advance to next level
  moveDelay     : 50   # number of milliseconds between moves
  respawnDelay  : 3000 # number of milliseconds until player can move again

  constructor: (@io) ->
    @levelIndex = 0
    @levels = Level.getAvailableLevels()
    @level = new Level @levels[@levelIndex]

    @frogCount = 0
    @spawnFrog()

    @players = []
    @playerCount = 0
    @io.on 'connection', @addPlayer

  loadNextLevel: =>
    @pause player for player in @players

    @levelIndex = (@levelIndex + 1) % @levels.length
    @level = new Level @levels[@levelIndex]
    @io.emit 'level', @level.getSnapshot()

    @frogCount = 0
    @spawnFrog()

    @respawn player, player.getLength() for player in @players

  addPlayer: (socket) =>
    newPlayer = new Player "Player #{++@playerCount}", socket, @onKey
    debug "#{newPlayer.name} joined."

    @players.push newPlayer

    socket.emit 'level', @level.getSnapshot()
    socket.on 'disconnect', => @removePlayer newPlayer.name

    @respawn newPlayer

  removePlayer: (name) =>
    debug "#{name} left."
    [player] = _.remove @players, 'name', name
    @unoccupy player.segments if player

  pause: (player) =>
    player.socket.removeListener 'key', player.keyListener
    @stopAutoMove player

  unpause: (player) =>
    player.socket.on 'key', player.keyListener
    @startAutoMove player

  stopAutoMove: (player) =>
    if player.moveTimer
      clearInterval player.moveTimer
      player.moveTimer = null

  startAutoMove: (player) =>
    unless player.moveTimer
      player.moveTimer = setInterval @autoMove(player), @moveDelay

  onKey: (player) => (keyCode) =>
    switch keyCode
      when keyCodes.LEFT_ARROW  then @changeDirection player, 'LEFT'
      when keyCodes.RIGHT_ARROW then @changeDirection player, 'RIGHT'
      when keyCodes.UP_ARROW    then @changeDirection player, 'UP'
      when keyCodes.DOWN_ARROW  then @changeDirection player, 'DOWN'

  changeDirection: (player, newDirection) =>
    newPos = player.changeDirection newDirection
    if newPos
      @stopAutoMove player
      @move player, newPos

  autoMove: (player) => =>
    newPos = player.getTheoreticalNewPos()
    @move player, newPos if newPos

  move: (player, theoreticalPos) =>
    newPos = @level.getActualPos theoreticalPos
    if @level.isWall newPos
      @respawn player
    else if @level.getOccupant newPos
      occupant = @level.getOccupant newPos
      if occupant.type is 'FROG'
        @unoccupy [newPos]
        occupant.affect player, @getOtherPlayers(player)
        if ++@frogCount < @frogsPerLevel
          @spawnFrog()
        else
          @loadNextLevel()
      else
        @handleCollision player, occupant, newPos
    else
      @occupy player, newPos
      vacatedPos = player.move newPos
      @unoccupy [vacatedPos] if vacatedPos
      @startAutoMove player

  getOtherPlayers: (player) =>
    @players.filter (otherPlayer) -> otherPlayer.name isnt player.name

  handleCollision: (player, occupant, newPos) =>
    if occupant.name isnt player.name
      if newPos is occupant.getHeadPos() # head-on collision
        @respawn player
        @respawn occupant
      else
        @respawn player
    else
      @respawn player

  respawn: (player, length) =>
    @pause player
    @unoccupy player.segments
    spawnPos = @level.getRandomSpawnPos()
    player.spawn spawnPos, length
    @occupy player, spawnPos
    setTimeout (=> @unpause player), @respawnDelay

  spawnFrog: =>
    frog = new Frog
    position = @level.getRandomSpawnPos()
    { char, row, col } = @level.occupy frog, position
    @io.emit 'display', { char, row, col }

  occupy: (occupant, position) =>
    { char, row, col } = @level.occupy occupant, position
    @io.emit 'display', { char, row, col }
    return { row, col }

  unoccupy: (positions) =>
    for position in positions
      { char } = @level.unoccupy position
      @io.emit 'display', { char, row: position.row, col: position.col }

module.exports = Game
