#!/bin/bash

#THE_USER=postgres
THE_USER=msa
THE_DB=amibroker
THE_TABLE1=stock_trx_idx
PSQL=/usr/bin/psql
THE_DIR=/home/msa/www/stock/new/bei-files/insert
THE_FILE1=$THE_DIR/stockTrxIdx.csv

logdate=`date '+%Y%m%d%H%m'`
echo $logdate

#------------------- Process Master Table Stock_trx_idx
read -p "Enter startDate date , Format --> (YYMMDD) : " dateDwl1
read -p "Enter endDate date , Format --> (YYMMDD) : " dateDwl2


#----------- Use it later to add date into csv files
fullDt1="20"${dateDwl1:0:2}"-"${dateDwl1:2:2}"-"${dateDwl1:4:2}
fullDt2="20"${dateDwl2:0:2}"-"${dateDwl2:2:2}"-"${dateDwl2:4:2}
AMIFILE=$THE_DIR/amibroker_20$dateDwl1'_'20$dateDwl2'_'$logdate.txt

echo " ------------- Generating Amibroker feed file ------------"

#------------------- Refresh SP
#${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
#SELECT count(*) FROM sp_stock_master_forbidden();
#OMG

#------------------ Create amibroker file 
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
\COPY (SELECT id_ticker, dt_trx, open_prc, high_prc, low_prc, close_prc, volume_trx, freq_trx, nbsa_prc FROM stock_trx_idx WHERE DT_TRX BETWEEN '$fullDt1' AND '$fullDt2' order by 2,1 asc) TO $AMIFILE WITH CSV DELIMITER ',';
OMG
