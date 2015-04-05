_     = require 'lodash'
debug = require('debug')('game')

keys = require './keys'

Level  = require './Level'
Player = require './Player'
Frog   = require './creatures/Frog'
Bonus  = require './creatures/Bonus'

class Game

  frogsPerLevel : 3     # number of frogs required to advance to next level
  moveDelay     : 70    # number of milliseconds between moves
  respawnDelay  : 3000  # number of milliseconds until player can move again
  bonusDelay    : 10000 # number of milliseconds until new bonus appears
  vanishDelay   : 10000 # number of milliseconds until bonus vanishes

  constructor: (@io) ->
    @levelIndex = 0
    @levels = Level.getAvailableLevels()
    @level = new Level @levels[@levelIndex]

    @frogCount = 0
    @spawnFrog()
    @bonusTimer = setInterval @spawnBonus, @bonusDelay

    @players = []
    @playerCount = 0
    @io.on 'connection', @addPlayer

  loadNextLevel: =>
    @pause player for player in @players
    clearInterval @bonusTimer

    @levelIndex = (@levelIndex + 1) % @levels.length
    @level = new Level @levels[@levelIndex]
    @io.emit 'level', @level.getSnapshot()

    @frogCount = 0
    @spawnFrog()

    @bonusTimer = setInterval @spawnBonus, @bonusDelay

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
    player.paused = true
    player.socket.removeListener 'key', player.keyListener
    @stopAutoMove player

  unpause: (player) =>
    player.paused = false
    player.socket.on 'key', player.keyListener
    @startAutoMove player
    { row, col } = player.getHeadPos()
    @io.emit 'display', { char: @level.symbolAt(row, col), row, col }

  stopAutoMove: (player) =>
    if player.moveTimer
      clearInterval player.moveTimer
      player.moveTimer = null

  startAutoMove: (player) =>
    unless player.moveTimer
      player.moveTimer = setInterval @autoMove(player), @moveDelay

  onKey: (player) => (keyCode) =>
    switch keys[keyCode]
      when 'LEFT_ARROW'  then @changeDirection player, 'LEFT'
      when 'RIGHT_ARROW' then @changeDirection player, 'RIGHT'
      when 'UP_ARROW'    then @changeDirection player, 'UP'
      when 'DOWN_ARROW'  then @changeDirection player, 'DOWN'

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
    occupant = @level.getOccupant newPos
    if @level.isWall newPos
      @respawn player
    else if occupant?.type is 'PLAYER'
      @handleCollision player, occupant, newPos
    else
      if occupant
        @unoccupy [newPos]
        { vacated, stay } = occupant.affect player, @getOtherPlayers(player)
        @unoccupy vacated if vacated?.length
        clearTimeout occupant.vanishTimer if occupant.vanishTimer
      unless stay
        @occupy player, newPos
        vacatedPos = player.move newPos
        @unoccupy [vacatedPos] if vacatedPos
      if occupant?.type is 'FROG'
        if ++@frogCount < @frogsPerLevel
          @spawnFrog()
        else
          @loadNextLevel()
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
    @occupy frog, position

  spawnBonus: =>
    bonus = new Bonus
    position = @level.getRandomSpawnPos()
    @occupy bonus, position
    bonus.vanishTimer = setTimeout (=> @unoccupy [position]), @vanishDelay

  occupy: (occupant, position) =>
    { char, row, col } = @level.occupy occupant, position
    @io.emit 'display', { char, row, col }

  unoccupy: (positions) =>
    uniquePositions = _.uniq positions, (pos) -> "#{pos.row},#{pos.col}"
    for position in uniquePositions
      { char } = @level.unoccupy position
      @io.emit 'display', { char, row: position.row, col: position.col }

module.exports = Game
