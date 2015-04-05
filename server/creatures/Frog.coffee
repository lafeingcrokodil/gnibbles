
class Frog

  type: 'FROG'
  lengthBonus: 5

  affect: (player, otherPlayers) =>
    { row, col } = player.getTailPos()
    for i in [1..@lengthBonus]
      player.segments.push { row, col }

module.exports = Frog
