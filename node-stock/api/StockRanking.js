const 
  express = require('express'),
  router = express.Router(),
  queries = require('../db/Stockranking-db'),
  config = require('../utils/setting');

function isValidId(req, res, next) {
  if(!isNaN(req.params.id)) return next();
  next(new Error('Invalid ID'));
}

router.get('/volume', (req, res) => {
  queries.getStockByVolume().then(stockVolume => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockVolume, undefined, undefined));
  });
});

router.get('/amount', (req, res) => {
  queries.getStockByAmount().then(stockAmount => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockAmount, undefined, undefined));
  });
});

module.exports = router;