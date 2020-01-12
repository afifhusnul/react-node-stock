const 
  express = require('express'),
  router = express.Router(),
  queries = require('../db/Stockbear-db'),
  config = require('../utils/setting');

function isValidId(req, res, next) {
  if(!isNaN(req.params.id)) return next();
  next(new Error('Invalid ID'));
}


router.get('/', (req, res) => {
  queries.getAll().then(stockBear => {
    // res.json(stockBear);
    res.json(config.rest.createResponse(200, stockBear, undefined, undefined));
  });
});

router.get('/1', (req, res) => {
  queries.getAll1().then(stockBear1 => {    
    res.json(config.rest.createResponse(200, stockBear1, undefined, undefined));
  });
});

router.get('/2', (req, res) => {
  queries.getAll2().then(stockBear2 => {    
    res.json(config.rest.createResponse(200, stockBear2, undefined, undefined));
  });
});

router.get('/3', (req, res) => {
  queries.getAll3().then(stockBear3 => {    
    res.json(config.rest.createResponse(200, stockBear3, undefined, undefined));
  });
});

router.get('/:id', isValidId, (req, res, next) => {
  queries.getOne(req.params.id).then(stockBear => {
    if(stockBear) {
      //res.json(StockBear);
      res.json(config.rest.createResponse(200, stockBear, undefined, undefined));
    } else {
      next();
    }
  });
});


module.exports = router;  

// module.exports.getAllStockBear = (req, res) => new Promise((resolve, reject) => {
// 	 queries.getAll().then(stockBear => {
//    //res.json(masterStock);   
//    res.json(config.rest.createResponse(200, stockBear, undefined, undefined));
//   });

// })