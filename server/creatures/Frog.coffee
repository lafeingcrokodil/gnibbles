
class Frog

  type: 'FROG'
  points: 5

  affect: (player, otherPlayers) =>
    { row, col } = player.getTailPos()
    for i in [1..@points]
      player.segments.push { row, col }
    return { dScore: @points }

module.exports = Frog
