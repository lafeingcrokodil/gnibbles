Axolotl = require './Axolotl'

class Toad extends Axolotl

  type: 'TOAD'
  points: 5

  affect: (player, otherPlayers) =>
    for otherPlayer in otherPlayers
      @reverseDirection otherPlayer
    return { dScore: @points }

module.exports = Toad
