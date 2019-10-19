#!/bin/bash

#----------- Define file
fileSS=SS
fileSO=SO
fileFI=FI
fileSQ=SQ

#----------- Define Url
baseUrl=http://www.idxdata.co.id
dwl_1=Download_Data/Daily/Stock_Summary/SS
dwl_2=Download_Data/Daily/Stock_First_Trx/SO
dwl_3=Download_Data/Daily/Foreign_Avail/FI
dwl_4=Market_Summary/Stock_Quotation/SQ

#----------- Define Download Folder
dbf2csv=/home/msa/www/stock/new/dbf2csv.py
baseFolder=/home/msa/www/stock/new/bei-files
/usr/bin/rm $baseFolder/siap.txt


#----------- Start download files
read -p "Enter date , Format --> (YYMMDD) : " dateDwl

echo $baseUrl/$dwl_1$dateDwl.zip >> $baseFolder/siap.txt
echo $baseUrl/$dwl_2$dateDwl.zip >> $baseFolder/siap.txt
echo $baseUrl/$dwl_3$dateDwl.zip >> $baseFolder/siap.txt
echo $baseUrl/$dwl_4$dateDwl.TXT >> $baseFolder/siap.txt

#----------- Download file in bulk
wget -i $baseFolder/siap.txt -P $baseFolder

#----------- Processing SS File
/usr/bin/unzip $baseFolder/$fileSS$dateDwl.zip -d $baseFolder > /dev/null
/usr/bin/rm $baseFolder/$fileSS$dateDwl.zip
/usr/bin/mv $baseFolder/$fileSS$dateDwl.DBF $baseFolder/$fileSS$dateDwl.dbf
$dbf2csv $baseFolder/$fileSS$dateDwl.dbf
/usr/bin/rm $baseFolder/$fileSS$dateDwl.dbf

#----------- Processing SO File
/usr/bin/unzip $baseFolder/$fileSO$dateDwl.zip -d $baseFolder > /dev/null
/usr/bin/rm $baseFolder/$fileSO$dateDwl.zip
/usr/bin/mv $baseFolder/$fileSO$dateDwl.DBF $baseFolder/$fileSO$dateDwl.dbf
$dbf2csv $baseFolder/$fileSO$dateDwl.dbf
/usr/bin/rm $baseFolder/$fileSO$dateDwl.dbf

#----------- Processing FI File
/usr/bin/unzip $baseFolder/$fileFI$dateDwl.zip -d $baseFolder > /dev/null
/usr/bin/rm $baseFolder/$fileFI$dateDwl.zip
/usr/bin/mv $baseFolder/$fileFI$dateDwl.DBF $baseFolder/$fileFI$dateDwl.dbf
$dbf2csv $baseFolder/$fileFI$dateDwl.dbf
/usr/bin/rm $baseFolder/$fileFI$dateDwl.dbf

#----------- Processing SQ File
#/usr/bin/wget $baseUrl/$dwl_4$dateDwl.txt -P $baseFolder > /dev/null
/usr/bin/mv $baseFolder/$fileSQ$dateDwl.TXT $baseFolder/$fileSQ$dateDwl.txt


#----------- List file
ls -l $baseFolder
