#!/bin/bash

#THE_USER=postgres
THE_USER=msa
THE_DB=amibroker
THE_TABLE1=stock_trx_idx
PSQL=/usr/bin/psql
THE_DIR=/home/msa/www/stock/bei-files/insert

logdate=`date '+%Y%m%d%H%m'`
#echo $logdate

#----------- Use it later to add date into csv files
fullDt1="20"${1:0:2}"-"${1:2:2}"-"${1:4:2}
fullDt2="20"${1:0:2}"-"${1:2:2}"-"${1:4:2}
AMIFILE=$THE_DIR/amibroker_20$1'_'20$1'_'$logdate.txt

echo " ------------- Generating Amibroker feed file ------------"

#------------------ Create amibroker file 
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
\COPY (SELECT id_ticker, dt_trx, open_prc, high_prc, low_prc, close_prc, volume_trx, freq_trx, nbsa_prc FROM stock_trx_idx WHERE DT_TRX BETWEEN '$fullDt1' AND '$fullDt2' and id_ticker in (select id_ticker from stock_master) order by 2,1 asc) TO $AMIFILE WITH CSV DELIMITER ',';
OMG
