class Screen

  constructor: (canvas, @numRows, @numCols, @tileSize) ->
    @context = canvas.getContext '2d'

    @width = canvas.width = @numCols * @tileSize
    @height = canvas.height = @numRows * @tileSize + 1

  getX: (col) => col * @tileSize

  getY: (row) => (row + 1) * @tileSize

  display: (char, row, col) =>
    @context.clearRect @getX(col), @getY(row-1) + 1, @tileSize, @tileSize
    switch char
      when '@'
        @context.fillStyle = 'green'
        @context.fillRect @getX(col) + 1, @getY(row-1) + 2, @tileSize - 2, @tileSize - 2
      when '-', '|', '+'
        @context.fillStyle = 'red'
        @context.fillRect @getX(col) + 1, @getY(row-1) + 2, @tileSize - 2, @tileSize - 2
      when 'F'
        @context.fillStyle = 'yellow'
        @context.fillRect @getX(col) + 1, @getY(row-1) + 2, @tileSize - 2, @tileSize - 2

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
