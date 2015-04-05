_ = require 'lodash'

class Player

  type: 'PLAYER'
  segments: []
  paused: true
  score: 0

  initialLength : 5 # initial length of snake (number of segments)
  minimumLength : 2 # minimum length of snake (number of segments)

  constructor: (@id, @socket, keyListener) ->
    @keyListener = keyListener @

  changeScore: (dScore) =>
    @score = Math.max 0, @score + dScore

  spawn: ({ row, col }, length = @initialLength) ->
    @direction = null
    @segments = []
    while @segments.length < length
      @segments.push { row, col }

  changeDirection: (newDirection) =>
    bothHorizontal = @direction in ['LEFT', 'RIGHT'] and newDirection in ['LEFT', 'RIGHT']
    bothVertical   = @direction in ['UP', 'DOWN'] and newDirection in ['UP', 'DOWN']
    unless bothHorizontal or bothVertical
      @direction = newDirection
      return @getTheoreticalNewPos()

  getTheoreticalNewPos: =>
    { row: oldRow, col: oldCol } = @segments[0]
    return switch @direction
      when 'LEFT'  then { row: oldRow, col: oldCol - 1 }
      when 'RIGHT' then { row: oldRow, col: oldCol + 1 }
      when 'UP'    then { row: oldRow - 1, col: oldCol }
      when 'DOWN'  then { row: oldRow + 1, col: oldCol }

  move: ({ row, col }) =>
    @segments.unshift { row, col }
    lastPos = @segments.pop()
    return lastPos unless _.isEqual @getTailPos(), lastPos

  getLength  : => @segments.length
  getHeadPos : => @segments[0]
  getTailPos : => _.last @segments

module.exports = Player
