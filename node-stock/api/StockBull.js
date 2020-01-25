const 
  express = require('express'),
  router = express.Router(),
  queries = require('../db/Stockbull-db'),
  config = require('../utils/setting');

function isValidId(req, res, next) {
  if(!isNaN(req.params.id)) return next();
  next(new Error('Invalid ID'));
}


router.get('/', (req, res) => {
  queries.getAll().then(stockBull => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockBull, undefined, undefined));
  });
});

router.get('/1', (req, res) => {
  queries.getAll1().then(stockBull1 => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockBull1, undefined, undefined));
  });
});

router.get('/2', (req, res) => {
  queries.getAll2().then(stockBull2 => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockBull2, undefined, undefined));
  });
});

router.get('/3', (req, res) => {
  queries.getAll3().then(stockBull3 => {
    //res.json(StockBear);
    res.json(config.rest.createResponse(200, stockBull3, undefined, undefined));
  });
});


module.exports = router;