class Screen

  maxPlayers: 8

  constructor: (canvas, @numRows, @numCols, @tileSize) ->
    @context = canvas.getContext '2d'

    @width = canvas.width = @numCols * @tileSize
    @height = canvas.height = (@numRows + 2) * @tileSize

    @scoreWidth = Math.floor @width / @maxPlayers / @tileSize
    @context.font = '800 12px courier'

  getX: (col) => col * @tileSize

  getY: (row) => (row + 1) * @tileSize

  updateScore: (id, score) =>
    @context.clearRect @getX(id*@scoreWidth), @getY(@numRows), @scoreWidth*@tileSize, @tileSize
    @display "#{id}", @numRows + 1, id*@scoreWidth
    @context.fillStyle = 'green'
    @context.fillText "#{score}", @getX(id*@scoreWidth + 1) + 3, @getY(@numRows + 1)

  display: (char, row, col) =>
    if char is 'A'
      creatures = ['G', 'B', 'T']
      index = @getRandomInt 0, creatures.length
      char = creatures[index]
    @context.clearRect @getX(col), @getY(row-1), @tileSize, @tileSize
    offset = Math.floor @tileSize/3
    switch char
      when '1'
        @fillCircle row, col, 'green'
      when '2'
        @fillCircle row, col, 'yellow'
      when '3'
        @fillCircle row, col, 'lime'
      when '4'
        @fillCircle row, col, 'saddlebrown'
      when '5'
        @fillCircle row, col, 'greenyellow'
      when '6'
        @fillCircle row, col, 'darkolivegreen'
      when '7'
        @fillCircle row, col, 'darkgreen'
      when '8'
        @fillCircle row, col, 'peru'
      when '?'
        @fillCircle row, col, 'grey'
      when '*'
        @fillSquare row, col, 'green'
      when 'G'
        @fillTriangle row, col, 'orangered'
      when 'B'
        @fillTriangle row, col, 'orange'
      when 'T'
        @fillUpsideDownTriangle row, col, 'firebrick'
      when '-'
        @context.strokeStyle = 'green'
        @context.beginPath()
        @context.moveTo(@getX(col), @getY(row-1) + offset)
        @context.lineTo(@getX(col+1), @getY(row-1) + offset)
        @context.moveTo(@getX(col), @getY(row) - offset)
        @context.lineTo(@getX(col+1), @getY(row) - offset)
        @context.stroke()
      when '|'
        @context.strokeStyle = 'green'
        @context.beginPath()
        @context.moveTo(@getX(col) + offset, @getY(row-1))
        @context.lineTo(@getX(col) + offset, @getY(row))
        @context.moveTo(@getX(col+1) - offset, @getY(row-1))
        @context.lineTo(@getX(col+1) - offset, @getY(row))
        @context.stroke()
      when '{'
        @context.strokeStyle = 'green'
        @context.beginPath()
        @context.moveTo(@getX(col) + offset, @getY(row))
        @context.lineTo(@getX(col) + offset, @getY(row-1) + offset)
        @context.lineTo(@getX(col+1), @getY(row-1) + offset)
        @context.moveTo(@getX(col+1) - offset, @getY(row))
        @context.lineTo(@getX(col+1) - offset, @getY(row) - offset)
        @context.lineTo(@getX(col+1), @getY(row) - offset)
        @context.stroke()
      when '}'
        @context.strokeStyle = 'green'
        @context.beginPath()
        @context.moveTo(@getX(col), @getY(row-1) + offset)
        @context.lineTo(@getX(col+1) - offset, @getY(row-1) + offset)
        @context.lineTo(@getX(col+1) - offset, @getY(row))
        @context.moveTo(@getX(col), @getY(row) - offset)
        @context.lineTo(@getX(col) + offset, @getY(row) - offset)
        @context.lineTo(@getX(col) + offset, @getY(row))
        @context.stroke()
      when '['
        @context.strokeStyle = 'green'
        @context.beginPath()
        @context.moveTo(@getX(col) + offset, @getY(row-1))
        @context.lineTo(@getX(col) + offset, @getY(row) - offset)
        @context.lineTo(@getX(col+1), @getY(row) - offset)
        @context.moveTo(@getX(col+1) - offset, @getY(row-1))
        @context.lineTo(@getX(col+1) - offset, @getY(row-1) + offset)
        @context.lineTo(@getX(col+1), @getY(row-1) + offset)
        @context.stroke()
      when ']'
        @context.strokeStyle = 'green'
        @context.beginPath()
        @context.moveTo(@getX(col), @getY(row-1) + offset)
        @context.lineTo(@getX(col) + offset, @getY(row-1) + offset)
        @context.lineTo(@getX(col) + offset, @getY(row-1))
        @context.moveTo(@getX(col), @getY(row) - offset)
        @context.lineTo(@getX(col+1) - offset, @getY(row) - offset)
        @context.lineTo(@getX(col+1) - offset, @getY(row-1))
        @context.stroke()
      when '+'
        @context.strokeStyle = 'green'
        @context.strokeRect @getX(col) + 1, @getY(row-1) + 1, @tileSize - 2, @tileSize - 2

  fillCircle: (row, col, colour) =>
    radius = Math.floor @tileSize/2
    centre = { x: @getX(col) + radius, y: @getY(row-1) + radius }
    @context.fillStyle = colour
    @context.beginPath()
    @context.arc(centre.x, centre.y, radius - 2, 0, 2*Math.PI)
    @context.fill()

  fillSquare: (row, col, colour) =>
    @context.fillStyle = colour
    @context.fillRect @getX(col) + 1, @getY(row-1) + 1, @tileSize - 2, @tileSize - 2

  fillTriangle: (row, col, colour) =>
    half = Math.floor @tileSize/2
    @context.fillStyle = colour
    @context.beginPath()
    @context.moveTo @getX(col) + 1, @getY(row) - 1
    @context.lineTo @getX(col) + half, @getY(row-1) + 1
    @context.lineTo @getX(col+1) - 1, @getY(row) - 1
    @context.fill()

  fillUpsideDownTriangle: (row, col, colour) =>
    half = Math.floor @tileSize/2
    @context.fillStyle = colour
    @context.beginPath()
    @context.moveTo @getX(col) + 1, @getY(row-1) + 1
    @context.lineTo @getX(col) + half, @getY(row) - 1
    @context.lineTo @getX(col+1) - 1, @getY(row-1) + 1
    @context.fill()

  getRandomInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

  displayLevel: (level) =>
    for row, i in level
      for char, j in row
        @display char, i, j

$(document).ready ->
  socket = io()

  socket.on 'level', (data) ->
    screen = new Screen $('canvas')[0], data.numRows, data.numCols, data.tileSize
    $('canvas').css 'display', 'block' # make screen visible
    screen.displayLevel data.tiles
    socket.on 'display', ({ char, row, col }) ->
      screen.display char, row, col
    socket.on 'score', ({ id, score }) ->
      screen.updateScore id, score

  $(document).keydown (e) ->
    socket.emit 'key', e.which
    e.preventDefault()
