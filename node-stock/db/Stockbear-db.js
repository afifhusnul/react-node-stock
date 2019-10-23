const knex = require('./knex-db'); // the connection!

module.exports = {  
  getAll() {
    return knex('stock_go_down');
  },
  getAll1() {
    return knex('stock_go_down1');
  },
  getAll2() {
    return knex('stock_go_down2');
  },
  getAll3() {
    return knex('stock_go_down3');
  },
  // getOne(id) {
  //   return knex('stock_go_up').where('id', id).first();
  // }
   
}
