_    = require 'lodash'
fs   = require 'fs'
path = require 'path'

symbols = require './symbols'

class Level

  tileSize: 10

  constructor: (level) ->
    @tiles = @loadFromFile level

    @numRows = @tiles.length
    @numCols = @tiles[0].length

    @wallSymbols = _.values _.filter(symbols, (symbol, symbolName) -> /^WALL/.test symbolName)

  loadFromFile: (level) ->
    levelFile = fs.readFileSync path.join('server', 'levels', "#{level}.txt"), 'utf8'

    tiles = []
    for row in levelFile.split /[\r\n]+/
      tiles.push row.split('').map (char) => { terrain: char }

    return tiles

  getActualPos: ({ row, col }) =>
    switch
      when row < 0 then row = @numRows - 1
      when row >= @numRows then row = 0
      when col < 0 then col = @numCols - 1
      when col >= @numCols then col = 0
    return { row, col }

  occupy: (occupant, row, col) =>
    unless row? and col?
      { row, col } = @getRandomSpawnPos()
    @tiles[row][col].occupant = occupant
    return { char: @symbolAt(row, col), row, col }

  unoccupy: (row, col) =>
    @tiles[row][col].occupant = null
    return { char: @symbolAt(row, col) }

  getRandomSpawnPos: =>
    loop # trial and error
      row = Math.floor(@numRows * Math.random())
      col = Math.floor(@numCols * Math.random())
      break if @isValidSpawnPos row, col
    return { row, col }

  isValidSpawnPos: (row, col) =>
    terrainOK = @tiles[row][col].terrain is symbols.GROUND
    noOccupant = not @getOccupant row, col
    return terrainOK and noOccupant

  isWall: ({ row, col }) =>
    @tiles[row]?[col]?.terrain in @wallSymbols

  getOccupant: ({ row, col }) =>
    return @tiles[row]?[col]?.occupant

  getSnapshot: =>
    tiles = []
    for row in @tiles
      tiles.push row.map (tile) => @getSymbol tile
    return { tiles, numRows: @numRows, numCols: @numCols, tileSize: @tileSize }

  symbolAt: (row, col) =>
    @getSymbol @tiles[row][col]

  getSymbol: (tile) ->
    if tile.occupant then symbols[tile.occupant.type] else tile.terrain

  @getAvailableLevels: ->
    fs.readdirSync(path.join('server', 'levels')).map (filename) ->
      filename.replace /\.txt/, ''

module.exports = Level
