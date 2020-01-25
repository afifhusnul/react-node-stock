const 
  express = require('express'),
  router = express.Router(),
  queries = require('../db/Stockressupport-db'),
  config = require('../utils/setting');


router.get('/:id', (req, res, next) => {
  const input = req.params.id.toUpperCase();
  queries.getOne(input).then(StockResSupport => {
    if(StockResSupport) {      
      res.json(config.rest.createResponse(200, StockResSupport, undefined, undefined));
    } else {
      next();
    }
  });
});


module.exports = router;