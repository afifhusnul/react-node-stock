const knex = require('./knex-db'); // the connection!

module.exports = {
  getAll() {
    return knex('stock_master')
    // return knex('stock_master').paginate(15, 1, true)
    //  .then(paginator => {
    //     console.log(paginator.current_page);
    //     console.log(paginator.data);
    // });

  },
  getOne(id) {
    return knex('stock_master').where('id_ticker', id);
  },
  getStock(id, startDt, endDt) {
    return knex('stock_trx_idx')
    .where('id_ticker', id)
    .whereBetween('dt_trx', [startDt, endDt]);
  }
  // create(stockmaster) {
  //   return knex('stock_master').insert(stockmaster, '*');
  // },
  // update(id, stockmaster) {
  //   return knex('stock_master').where('id_ticker', id).update(stockmaster, '*');
  // },
  // delete(id) {
  //   return knex('stock_master').where('id_ticker', id).del();
  // }
}