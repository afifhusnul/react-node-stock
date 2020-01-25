const knex = require('./knex-db'); // the connection!

module.exports = {
  
  getOne(id) {
    return knex('stock_info_res_sup').where('id_ticker', id).first();
  }
   
}
