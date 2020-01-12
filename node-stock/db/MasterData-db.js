const knex = require('./knex-db'); // the connection!

module.exports = {
  getAllBajul() {
    return knex('v_stock_ready_amibroker')
  },
  getOne(id) {
    return knex('stock_master').where('id_ticker', id);
  }  
}