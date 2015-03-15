express = require 'express'
router  = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index',
    title: 'Gnibbles'
    canvasWidth: 800
    canvasHeight: 600

module.exports = router
