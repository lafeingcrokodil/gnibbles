express = require 'express'
router  = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index', title: 'Gnibbles'

module.exports = router
