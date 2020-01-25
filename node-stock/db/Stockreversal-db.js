const knex = require('./knex-db'); // the connection!

module.exports = {  
  getReversalUp() {
    return knex('stock_reversal_up');
  },
  getReversalDown() {
    return knex('stock_reversal_down');
  }
   
}
