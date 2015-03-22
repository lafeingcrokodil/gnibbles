class Screen

  constructor: (canvas, @numRows, @numCols, @tileSize) ->
    @context = canvas.getContext '2d'

    @width = canvas.width = @numCols * @tileSize
    @height = canvas.height = (@numRows + 2) * @tileSize

  getX: (col) => col * @tileSize

  getY: (row) => (row + 1) * @tileSize

  display: (char, row, col) =>
    @context.clearRect @getX(col), @getY(row-1) + 1, @tileSize, @tileSize
    switch char
      when '@'
        @context.fillStyle = 'green'
        @context.fillRect @getX(col), @getY(row-1) + 1, @tileSize, @tileSize
      when '#'
        @context.fillStyle = 'red'
        @context.fillRect @getX(col), @getY(row-1) + 1, @tileSize, @tileSize

  displayLevel: (level) =>
    for row, i in level
      for char, j in row
        @display char, i, j

$(document).ready ->
  name = prompt 'Please enter your name'
  socket = io()
  socket.emit 'join', name

  socket.on 'level', (data) ->
    screen = new Screen $('canvas')[0], data.numRows, data.numCols, data.tileSize
    $('canvas').css 'display', 'block' # make screen visible
    screen.displayLevel data.tiles
    socket.on 'display', ({ char, row, col }) ->
      screen.display char, row, col
