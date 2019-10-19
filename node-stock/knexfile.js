module.exports = {
  development: {
    client: 'pg',
    connection: 'postgres://postgres:postgres@localhost:5432/amibroker'
  },
  test: {
    client: 'pg',
    connection: 'postgres://postgres:postgres@localhost:5432/amibroker'
  },
  production: {
    client: 'pg',
    connection: process.env.DATABASE_URL
  },
  pool: {
    min: 2,
    max: 10,
    acquireConnectionTimeout: 10000,  
    afterCreate: (conn, done) => {
      conn.query('SET timezone="UTC";', (err)=>{
        if (err) {
          console.log(err)
        }
        done(err, conn)
      })
    }
  }
};
