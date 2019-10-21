#!/bin/bash

#THE_USER=postgres
THE_USER=msa
THE_DB=amibroker
THE_TABLE1=stock_trx_idx
THE_TABLE2=stock_trx_open
THE_TABLE3=stock_trx_nbsa
THE_TABLE4=stock_trx_freq
#PSQL=/snap/bin/postgresql10.psql
PSQL=/usr/bin/psql
THE_DIR=/home/msa/www/stock/new/bei-files/insert
THE_FILE1=$THE_DIR/stockTrxIdx.csv
THE_FILE2=$THE_DIR/stockTrxOpen.csv
THE_FILE3=$THE_DIR/stockTrxNbsa.csv
THE_FILE4=$THE_DIR/stockTrxFreq.txt

#------------------- Process Master Table Stock_trx_idx
echo " ------------- Master Table ------------"
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
\COPY ${THE_TABLE4} FROM '${THE_FILE2}' delimiter ',' csv;
OMG

#------------------- Refresh SP
${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
SELECT count(*) FROM sp_bajul_tr();
SELECT count(*) FROM sp_stock_master_forbidden();
OMG

