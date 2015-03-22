fs   = require 'fs'
path = require 'path'

symbols = require './symbols'

class Level

  tileSize: 5

  constructor: (level = '1') ->
    @tiles = @loadFromFile level

    @numRows = @tiles.length
    @numCols = @tiles[0].length

  loadFromFile: (level) ->
    levelFile = fs.readFileSync path.join('server', 'levels', "#{level}.txt"), 'utf8'

    tiles = []
    for row in levelFile.split /[\r\n]+/
      tiles.push row.split('').map (char) => { terrain: char }

    return tiles

  occupy: (occupant, row, col) =>
    unless row? and col?
      { row, col } = @getRandomSpawnPos()
    @tiles[row][col].occupant = occupant
    occupant.segments[0] = [row, col]
    return { char: @symbolAt(row, col), row, col }

  unoccupy: (row, col) =>
    @tiles[row][col].occupant = null
    return { char: @symbolAt(row, col) }

  getRandomSpawnPos: =>
    loop # trial and error
      row = Math.floor (@numRows * Math.random())
      col = Math.floor (@numCols * Math.random())
      break if @isValid(row, col) and not @getOccupant(row, col)
    return { row, col }

  isValid: (row, col) =>
    inBounds = 0 <= row < @numRows and 0 <= col < @numCols
    terrainOK = @tiles[row][col].terrain is symbols.GROUND
    return inBounds and terrainOK

  getOccupant: (row, col) =>
    return @tiles[row][col].occupant

  getSnapshot: =>
    tiles = []
    for row in @tiles
      tiles.push row.map (tile) => @getSymbol tile
    return { tiles, numRows: @numRows, numCols: @numCols, tileSize: @tileSize }

  symbolAt: (row, col) =>
    @getSymbol @tiles[row][col]

  getSymbol: (tile) ->
    if tile.occupant then symbols.PLAYER else tile.terrain

  getWidth: => @numCols * @tileSize

  getHeight: => @numRows * @tileSize

module.exports = Level
