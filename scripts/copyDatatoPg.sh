#!/bin/bash
#-------------- Base Folder
baseFolder=/home/msa/www/stock/new/bei-files

#!/bin/sh

THE_USER=postgres
THE_DB=amibroker
THE_TABLE=stock_trx_id
PSQL=/opt/postgresql/bin/psql
THE_DIR=/home/msa/www/stock/new/bei-files
THE_FILE=SS191018.csv

${PSQL} -U ${THE_USER} ${THE_DB} <<OMG
\COPY ${THE_TABLE} (id_ticker, dt_trx, open_prc, high_prc, low_prc, close_prc, volume_rx, value_prc) FROM '${THE_DIR}/${THE_FILE}' delimiter ',' csv;
OMG


#for x in $(ls $baseFolder/*.csv); 
#do PGPASSWORD=postgres psql  -U postgres -c "\copy stock_trx_id (id_ticker) from '$basefolder/$x' csv" -h <localhost>; done
