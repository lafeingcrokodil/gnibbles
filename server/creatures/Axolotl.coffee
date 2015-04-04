
class Axolotl

  type: 'AXOLOTL'

  affect: (player, otherPlayers) =>
    @reverseDirection player
    return { stay: true }

  reverseDirection: (player) ->
    player.segments.reverse()
    [first, second] = player.segments.slice 0, 2
    player.direction = switch
      when first.col > second.col then 'RIGHT'
      when first.col < second.col then 'LEFT'
      when first.row > second.row then 'DOWN'
      when first.row < second.row then 'UP'

module.exports = Axolotl
