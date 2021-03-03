const 
  express = require('express'),
  router = express.Router(),
  queries = require('../db/MasterStock-db'),
  config = require('../utils/setting');
// const db = require('../db/knex-db'); // the connection!
// const paginator = require('../db/knex-paginator.js');


router.get('/', (req, res) => {
  queries.getAll().then(masterStock => {
   //res.json(masterStock);   
   res.json(config.rest.createResponse(200, masterStock, undefined, undefined));
  });
});

router.get('/:id', (req, res, next) => {
  const input = req.params.id.toUpperCase();
  queries.getOne(input).then(masterStock => {
    if(masterStock) {
      //res.json(masterStock);
      res.json(config.rest.createResponse(200, masterStock, undefined, undefined));
    } else {
      next();
    }
  });
});

router.get('/:id/:startDt/:endDt', (req, res, next) => {
  const input = req.params.id.toUpperCase();
  const startDt = req.params.startDt;
  const endDt = req.params.endDt;
  queries.getStock(input,startDt,endDt).then(masterStock => {
    if(masterStock) {
      //res.json(masterStock);
      res.json(config.rest.createResponse(200, masterStock, undefined, undefined));
    } else {
      next();
    }
  });
});

router.post('/history', function (req,res) {
  const idTicker = req.body.idTicker.toUpperCase()
  const startDt = req.body.startDt
  const endDt = req.body.endDt
  
  queries.getSingle(idTicker,startDt,endDt).then(singleStock => {
    if(singleStock) {          
      res.json(config.rest.createResponse(200, singleStock, undefined, undefined));
    } else {
      next();
    }
  });
});


module.exports = router;