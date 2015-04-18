// Generated by CoffeeScript 1.9.1
(function() {
  var Screen,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Screen = (function() {
    Screen.prototype.maxPlayers = 8;

    function Screen(canvas, numRows, numCols, tileSize) {
      this.numRows = numRows;
      this.numCols = numCols;
      this.tileSize = tileSize;
      this.displayLevel = bind(this.displayLevel, this);
      this.fillUpsideDownTriangle = bind(this.fillUpsideDownTriangle, this);
      this.fillTriangle = bind(this.fillTriangle, this);
      this.fillSquare = bind(this.fillSquare, this);
      this.fillCircle = bind(this.fillCircle, this);
      this.display = bind(this.display, this);
      this.updateScore = bind(this.updateScore, this);
      this.getY = bind(this.getY, this);
      this.getX = bind(this.getX, this);
      this.context = canvas.getContext('2d');
      this.width = canvas.width = this.numCols * this.tileSize;
      this.height = canvas.height = (this.numRows + 2) * this.tileSize;
      this.scoreWidth = Math.floor(this.width / this.maxPlayers / this.tileSize);
      this.context.font = '800 12px courier';
    }

    Screen.prototype.getX = function(col) {
      return col * this.tileSize;
    };

    Screen.prototype.getY = function(row) {
      return (row + 1) * this.tileSize;
    };

    Screen.prototype.updateScore = function(id, score) {
      this.context.clearRect(this.getX(id * this.scoreWidth), this.getY(this.numRows), this.scoreWidth * this.tileSize, this.tileSize);
      this.display("" + id, this.numRows + 1, id * this.scoreWidth);
      this.context.fillStyle = 'green';
      return this.context.fillText("" + score, this.getX(id * this.scoreWidth + 1) + 3, this.getY(this.numRows + 1));
    };

    Screen.prototype.display = function(char, row, col) {
      var creatures, index, offset;
      if (char === 'A') {
        creatures = ['G', 'B', 'T'];
        index = this.getRandomInt(0, creatures.length);
        char = creatures[index];
      }
      this.context.clearRect(this.getX(col), this.getY(row - 1), this.tileSize, this.tileSize);
      offset = Math.floor(this.tileSize / 3);
      switch (char) {
        case '1':
          return this.fillCircle(row, col, 'green');
        case '2':
          return this.fillCircle(row, col, 'yellow');
        case '3':
          return this.fillCircle(row, col, 'lime');
        case '4':
          return this.fillCircle(row, col, 'saddlebrown');
        case '5':
          return this.fillCircle(row, col, 'greenyellow');
        case '6':
          return this.fillCircle(row, col, 'darkolivegreen');
        case '7':
          return this.fillCircle(row, col, 'darkgreen');
        case '8':
          return this.fillCircle(row, col, 'peru');
        case '?':
          return this.fillCircle(row, col, 'grey');
        case '*':
          return this.fillSquare(row, col, 'green');
        case 'G':
          return this.fillTriangle(row, col, 'orangered');
        case 'B':
          return this.fillTriangle(row, col, 'orange');
        case 'T':
          return this.fillUpsideDownTriangle(row, col, 'firebrick');
        case '-':
          this.context.strokeStyle = 'green';
          this.context.beginPath();
          this.context.moveTo(this.getX(col), this.getY(row - 1) + offset);
          this.context.lineTo(this.getX(col + 1), this.getY(row - 1) + offset);
          this.context.moveTo(this.getX(col), this.getY(row) - offset);
          this.context.lineTo(this.getX(col + 1), this.getY(row) - offset);
          return this.context.stroke();
        case '|':
          this.context.strokeStyle = 'green';
          this.context.beginPath();
          this.context.moveTo(this.getX(col) + offset, this.getY(row - 1));
          this.context.lineTo(this.getX(col) + offset, this.getY(row));
          this.context.moveTo(this.getX(col + 1) - offset, this.getY(row - 1));
          this.context.lineTo(this.getX(col + 1) - offset, this.getY(row));
          return this.context.stroke();
        case '{':
          this.context.strokeStyle = 'green';
          this.context.beginPath();
          this.context.moveTo(this.getX(col) + offset, this.getY(row));
          this.context.lineTo(this.getX(col) + offset, this.getY(row - 1) + offset);
          this.context.lineTo(this.getX(col + 1), this.getY(row - 1) + offset);
          this.context.moveTo(this.getX(col + 1) - offset, this.getY(row));
          this.context.lineTo(this.getX(col + 1) - offset, this.getY(row) - offset);
          this.context.lineTo(this.getX(col + 1), this.getY(row) - offset);
          return this.context.stroke();
        case '}':
          this.context.strokeStyle = 'green';
          this.context.beginPath();
          this.context.moveTo(this.getX(col), this.getY(row - 1) + offset);
          this.context.lineTo(this.getX(col + 1) - offset, this.getY(row - 1) + offset);
          this.context.lineTo(this.getX(col + 1) - offset, this.getY(row));
          this.context.moveTo(this.getX(col), this.getY(row) - offset);
          this.context.lineTo(this.getX(col) + offset, this.getY(row) - offset);
          this.context.lineTo(this.getX(col) + offset, this.getY(row));
          return this.context.stroke();
        case '[':
          this.context.strokeStyle = 'green';
          this.context.beginPath();
          this.context.moveTo(this.getX(col) + offset, this.getY(row - 1));
          this.context.lineTo(this.getX(col) + offset, this.getY(row) - offset);
          this.context.lineTo(this.getX(col + 1), this.getY(row) - offset);
          this.context.moveTo(this.getX(col + 1) - offset, this.getY(row - 1));
          this.context.lineTo(this.getX(col + 1) - offset, this.getY(row - 1) + offset);
          this.context.lineTo(this.getX(col + 1), this.getY(row - 1) + offset);
          return this.context.stroke();
        case ']':
          this.context.strokeStyle = 'green';
          this.context.beginPath();
          this.context.moveTo(this.getX(col), this.getY(row - 1) + offset);
          this.context.lineTo(this.getX(col) + offset, this.getY(row - 1) + offset);
          this.context.lineTo(this.getX(col) + offset, this.getY(row - 1));
          this.context.moveTo(this.getX(col), this.getY(row) - offset);
          this.context.lineTo(this.getX(col + 1) - offset, this.getY(row) - offset);
          this.context.lineTo(this.getX(col + 1) - offset, this.getY(row - 1));
          return this.context.stroke();
        case '+':
          this.context.strokeStyle = 'green';
          return this.context.strokeRect(this.getX(col) + 1, this.getY(row - 1) + 1, this.tileSize - 2, this.tileSize - 2);
      }
    };

    Screen.prototype.fillCircle = function(row, col, colour) {
      var centre, radius;
      radius = Math.floor(this.tileSize / 2);
      centre = {
        x: this.getX(col) + radius,
        y: this.getY(row - 1) + radius
      };
      this.context.fillStyle = colour;
      this.context.beginPath();
      this.context.arc(centre.x, centre.y, radius - 2, 0, 2 * Math.PI);
      return this.context.fill();
    };

    Screen.prototype.fillSquare = function(row, col, colour) {
      this.context.fillStyle = colour;
      return this.context.fillRect(this.getX(col) + 1, this.getY(row - 1) + 1, this.tileSize - 2, this.tileSize - 2);
    };

    Screen.prototype.fillTriangle = function(row, col, colour) {
      var half;
      half = Math.floor(this.tileSize / 2);
      this.context.fillStyle = colour;
      this.context.beginPath();
      this.context.moveTo(this.getX(col) + 1, this.getY(row) - 1);
      this.context.lineTo(this.getX(col) + half, this.getY(row - 1) + 1);
      this.context.lineTo(this.getX(col + 1) - 1, this.getY(row) - 1);
      return this.context.fill();
    };

    Screen.prototype.fillUpsideDownTriangle = function(row, col, colour) {
      var half;
      half = Math.floor(this.tileSize / 2);
      this.context.fillStyle = colour;
      this.context.beginPath();
      this.context.moveTo(this.getX(col) + 1, this.getY(row - 1) + 1);
      this.context.lineTo(this.getX(col) + half, this.getY(row) - 1);
      this.context.lineTo(this.getX(col + 1) - 1, this.getY(row - 1) + 1);
      return this.context.fill();
    };

    Screen.prototype.getRandomInt = function(min, max) {
      return Math.floor(Math.random() * (max - min)) + min;
    };

    Screen.prototype.displayLevel = function(level) {
      var char, i, j, k, len, results, row;
      results = [];
      for (i = k = 0, len = level.length; k < len; i = ++k) {
        row = level[i];
        results.push((function() {
          var l, len1, results1;
          results1 = [];
          for (j = l = 0, len1 = row.length; l < len1; j = ++l) {
            char = row[j];
            results1.push(this.display(char, i, j));
          }
          return results1;
        }).call(this));
      }
      return results;
    };

    return Screen;

  })();

  $(document).ready(function() {
    var socket;
    socket = io();
    socket.on('level', function(data) {
      var screen;
      screen = new Screen($('canvas')[0], data.numRows, data.numCols, data.tileSize);
      $('canvas').css('display', 'block');
      screen.displayLevel(data.tiles);
      socket.on('display', function(arg) {
        var char, col, row;
        char = arg.char, row = arg.row, col = arg.col;
        return screen.display(char, row, col);
      });
      return socket.on('score', function(arg) {
        var id, score;
        id = arg.id, score = arg.score;
        return screen.updateScore(id, score);
      });
    });
    return $(document).keydown(function(e) {
      socket.emit('key', e.which);
      return e.preventDefault();
    });
  });

}).call(this);
