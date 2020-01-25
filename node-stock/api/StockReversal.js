const 
  express = require('express'),
  router = express.Router(),
  queries = require('../db/Stockreversal-db'),
  config = require('../utils/setting');

function isValidId(req, res, next) {
  if(!isNaN(req.params.id)) return next();
  next(new Error('Invalid ID'));
}

router.get('/up', (req, res) => {
  queries.getReversalUp().then(stockReversalUp => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockReversalUp, undefined, undefined));
  });
});

router.get('/down', (req, res) => {
  queries.getReversalDown().then(stockReversalDown => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockReversalDown, undefined, undefined));
  });
});

module.exports = router;