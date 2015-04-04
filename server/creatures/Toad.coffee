Axolotl = require './Axolotl'

class Toad extends Axolotl

  type: 'TOAD'

  affect: (player, otherPlayers) =>
    for otherPlayer in otherPlayers
      @reverseDirection otherPlayer

module.exports = Toad
