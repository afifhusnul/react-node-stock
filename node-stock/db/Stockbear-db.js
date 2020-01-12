const knex = require('./knex-db'); // the connection!

module.exports = {  
  getAll() {
    return knex('mv_stock_go_down');
    //return knex('stock_trx_idx').where('dt_trx','2019-10-23').orderBy('id_ticker', 'asc');
    // return knex('bajul').orderBy('dt_trx', 'desc');
    //return knex.from('bajul').select('dt_trx', 'row_number').where('dt_trx', '2019-10-23');
  },
  getAll1() {
    return knex('mv_stock_go_down1');
  },
  getAll2() {
    return knex('mv_stock_go_down2');
  },
  getAll3() {
    return knex('mv_stock_go_down3');
  },
  // getOne(id) {
  //   return knex('stock_go_up').where('id', id).first();
  // }
   
}
