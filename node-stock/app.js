const 
  createError = require('http-errors'),
  express = require('express'),
  path = require('path'),
  cookieParser = require('cookie-parser'),
  logger = require('morgan'),
  bodyParser = require('body-parser'),
  cors = require('cors'),
  config = require('./utils/setting');


const app = express();

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());


//---------------- Cors --------------
app.use(cors());
app.use(function(req, res, next) {
   res.header("Access-Control-Allow-Origin", "*");
   res.header('Access-Control-Allow-Methods', 'DELETE, PUT, GET, POST');
   res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
   next();
});

// Api list
const masterStockData = require('./api/StockData');
app.use('/api/stockdata', masterStockData);

const masterStock = require('./api/StockMaster');
app.use('/api/stockmaster', masterStock);

const bullStock = require('./api/StockBull');
app.use('/api/bullstock', bullStock);

const bearStock = require('./api/StockBear');
app.use('/api/bearstock', bearStock);

const rankingStock = require('./api/StockRanking');
app.use('/api/ranking', rankingStock);

const reversalStock = require('./api/StockReversal');
app.use('/api/reversal', reversalStock);

const infoResSupportStock = require('./api/StockResSupport');
app.use('/api/stockinfo', infoResSupportStock);


// catch 404 and forward to error handler
app.use(function(req, res, next) {  
   res.json(config.rest.createResponse(404, undefined, undefined, 'Url API is not found'));
});

// error handler
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  next(err);
  res.json({
    message: err.message,
    error: req.app.get('env') === 'development' ? err : {}
  });
});


module.exports = app;
