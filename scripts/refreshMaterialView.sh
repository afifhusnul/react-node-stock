#!/bin/bash

#THE_USER=postgres
THE_USER=msa
THE_DB=amibroker
THE_MASTER_STOCK_TABLE=stock_master
THE_TABLE1=stock_trx_idx
THE_TABLE2=stock_trx_open
THE_TABLE3=stock_trx_nbsa
THE_TABLE4=stock_trx_freq
#PSQL=/snap/bin/postgresql10.psql
PSQL=/usr/bin/psql
THE_DIR=/home/msa/www/stock/new/bei-files/insert
THE_MASTER=$THE_DIR/stockMaster.csv
THE_FILE1=$THE_DIR/stockTrxIdx.csv
THE_FILE2=$THE_DIR/stockTrxOpen.csv
THE_FILE3=$THE_DIR/stockTrxNbsa.csv
THE_FILE4=$THE_DIR/stockTrxFreq.txt
AMI_FILE=$THE_DIR/amibroker.txt


#------------------- Refresh SP
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
SELECT count(*) FROM sp_refresh_mv_tr();
OMG

#------------------ Create amibroker file 
#${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
#\COPY (SELECT id_ticker, dt_trx, open_prc, high_prc, low_prc, close_prc, volume_trx, freq_trx, nbsa_prc FROM stock_trx_idx WHERE DT_TRX BETWEEN $1 AND $2) TO $AMI_FILE WITH CSV DELIMITER ',';
#OMG
