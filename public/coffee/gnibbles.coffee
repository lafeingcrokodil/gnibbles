class Screen

  constructor: (canvas, @numRows, @numCols, @tileSize) ->
    @context = canvas.getContext '2d'

    @width = canvas.width = @numCols * @tileSize
    @height = canvas.height = @numRows * @tileSize

  getX: (col) => col * @tileSize

  getY: (row) => (row + 1) * @tileSize

  display: (char, row, col) =>
    @context.clearRect @getX(col), @getY(row-1), @tileSize, @tileSize
    offset = Math.floor @tileSize/3
    switch char
      when '@'
        @fillCircle row, col, 'green'
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
      when '+'
        @context.strokeStyle = 'green'
        @context.strokeRect @getX(col) + 1, @getY(row-1) + 1, @tileSize - 2, @tileSize - 2
      when 'F'
        @fillCircle row, col, 'yellow'

  fillCircle: (row, col, colour) =>
    radius = Math.floor @tileSize/2
    centre = { x: @getX(col) + radius, y: @getY(row-1) + radius }
    @context.fillStyle = colour
    @context.beginPath()
    @context.arc(centre.x, centre.y, radius - 2, 0, 2*Math.PI)
    @context.fill()

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

  $(document).keydown (e) ->
    socket.emit 'key', e.which
    e.preventDefault()
