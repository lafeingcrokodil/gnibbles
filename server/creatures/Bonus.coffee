Axolotl  = require './Axolotl'
Bullfrog = require './Bullfrog'
Gecko    = require './Gecko'
Toad     = require './Toad'

class Bonus

  types: [Axolotl, Bullfrog, Gecko, Toad]

  constructor: ->
    index = @getRandomInt 0, @types.length
    return new @types[index]

  getRandomInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

module.exports = Bonus
