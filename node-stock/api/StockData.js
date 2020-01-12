const 
  express = require('express'),
  router = express.Router(),
  queries = require('../db/MasterData-db'),
  config = require('../utils/setting');

router.get('/', (req, res) => {
  queries.getAllBajul().then(masterStockData => {   
   res.json(config.rest.createResponse(200, masterStockData, undefined, undefined));
  });
});


module.exports = router;