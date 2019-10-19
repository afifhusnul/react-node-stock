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
  queries.getOne(req.params.id).then(masterStock => {
    if(masterStock) {
      //res.json(masterStock);
      res.json(config.rest.createResponse(200, masterStock, undefined, undefined));
    } else {
      next();
    }
  });
});


module.exports = router;