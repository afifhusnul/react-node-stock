const moment = require('moment');
const types = require('pg').types;
// const pg = require('pg');
// const builtins = require('pg-types');


// const parseFn = function(val) {
//    return val === null ? null : moment(val)
// }
// types.setTypeParser(types.builtins.TIMESTAMPTZ, parseFn)
// types.setTypeParser(types.builtins.TIMESTAMP, parseFn)


const DATE_OID = 1082;
const parseDate = (value) => value;

types.setTypeParser(DATE_OID, parseDate);



// function pgDateToUTC(dateValue) { 
//   //return new Date(dateValue + 'T00:00:00.000Z'); 
//   return new Date(dateValue).moment(dateValue).format('YYYY-MM-DD hh:mm:ss a'); 
// } 
// pg.types.setTypeParser(1082, pgDateToUTC);

module.exports = {
  development: {
    client: 'pg',
    connection: 'postgres://postgres:postgres@localhost:5432/amibroker',
    charset  : 'utf8'
  },
  test: {
    client: 'pg',
    connection: 'postgres://postgres:postgres@localhost:5432/amibroker',
    charset  : 'utf8'
  },
  production: {
    client: 'pg',
    connection: process.env.DATABASE_URL,
    charset  : 'utf8'
  },
  pool: {
    min: 2,
    max: 10,
    acquireConnectionTimeout: 10000,
    afterCreate: function(connection, callback) {
      connection.query('SET timezone="UTC";', error => {
        if (error) {
          console.log(error)
        } else {
          callback(error, connection);
        }

      })
      // connection.query('SET timezone = timezone;', function(err) {
      //   callback(err, connection);
      // });
    }
    // afterCreate: (conn, done) => {
    //   //conn.query('SET timezone="UTC+08";', (err)=>{
    //     conn.query("SET time_zone= timezone+08;'", error => {
    //     if (err) {
    //       console.log(err)
    //     }
    //     done(err, conn)
    //   })
    // }
  }
};
