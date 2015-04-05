
class Gecko

  type: 'GECKO'

  affect: (player, otherPlayers) =>
    newLength = Math.max player.segments.length/2, player.minimumLength
    removedSegments = []
    while player.segments.length > newLength
      removedSegments.push player.segments.pop()
    return { vacated: removedSegments, dScore: removedSegments.length }

module.exports = Gecko
