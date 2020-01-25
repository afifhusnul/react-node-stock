#!/bin/bash

export PGPASSWORD=digi123
#THE_USER=postgres
THE_USER=msa
THE_PASS=digi123
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

#------------------- Process Master Table Stock_trx_idx
echo " ------------- Master Table ------------"
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
TRUNCATE $THE_MASTER_STOCK_TABLE;
\COPY ${THE_MASTER_STOCK_TABLE} FROM '${THE_MASTER}' delimiter ',' csv;
DELETE FROM stock_master WHERE id_ticker like ('%-W');
DELETE FROM stock_master WHERE id_ticker like ('%-W2');
DELETE FROM stock_master WHERE nm_ticker like ('Reksa Dana%');
DELETE FROM stock_master WHERE nm_ticker like ('DIRE Ciptadana%');
OMG

${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
\COPY ${THE_TABLE1} FROM '${THE_FILE1}' delimiter ',' csv;
OMG


#------------------- Process Table Open
echo " ------------- Table Open ------------"
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
TRUNCATE ${THE_TABLE2};
\COPY ${THE_TABLE2} FROM '${THE_FILE2}' delimiter ',' csv;
OMG

#------------------- Process Table NBSA
echo " ------------- Table NBSA ------------"
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
TRUNCATE ${THE_TABLE3};
\COPY ${THE_TABLE3} FROM '${THE_FILE3}' delimiter ',' csv;
OMG

#------------------- Process Table Freq
echo " ------------- Table Freq ------------"
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
TRUNCATE ${THE_TABLE4};
\COPY ${THE_TABLE4} FROM '${THE_FILE4}' delimiter '|' csv;
OMG

#------------------- Refresh SP
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
SELECT count(*) FROM sp_bajul_tr();
SELECT count(*) FROM sp_stock_master_forbidden();
OMG

#------------------ Create amibroker file 
#${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
#\COPY (SELECT id_ticker, dt_trx, open_prc, high_prc, low_prc, close_prc, volume_trx, freq_trx, nbsa_prc FROM stock_trx_idx WHERE DT_TRX BETWEEN $1 AND $2) TO $AMI_FILE WITH CSV DELIMITER ',';
#OMG
