const knex = require('./knex-db'); // the connection!

module.exports = {
  getAll() {
    return knex('stock_go_down1');
  }
}