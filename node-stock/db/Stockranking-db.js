const knex = require('./knex-db'); // the connection!

module.exports = {
  getStockByAmount() {
    return knex('mv_stock_vol_amount');
  },
  getStockByVolume() {
    return knex('mv_stock_vol_melduk');
  },  
  // getOne(id) {
  //   return knex('stock_go_up').where('id', id).first();
  // }
   
}
