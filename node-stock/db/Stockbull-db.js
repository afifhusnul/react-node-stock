const knex = require('./knex-db'); // the connection!

module.exports = {  
  getAll() {
    return knex('mv_stock_go_up');
  },
  getAll1() {
    return knex('mv_stock_go_up1');
  },
  getAll2() {
    return knex('mv_stock_go_up2');
  },
  getAll3() {
    return knex('mv_stock_go_up3');
  }
   
}
