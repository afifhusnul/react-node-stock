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

file1=$baseFolder/insert/stockTrxIdx.csv
file2=$baseFolder/insert/stockTrxOpen.csv
file3=$baseFolder/insert/stockTrxNbsa.csv
file4=$baseFolder/insert/stockTrxFreq.txt
tempfile4=$baseFolder/insert/stockTrxFreq_1.txt
/usr/bin/rm $baseFolder/siap.txt
/usr/bin/rm $file1 $file2 $file3 $file4 $tempFile4

read -p "Enter date , Format --> (YYMMDD) : " dateDwl

fullDt="20"${dateDwl:0:2}"-"${dateDwl:2:2}"-"${dateDwl:4:2}


#----------- Start download files

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
#------------------ Master Stock
awk -F',' 'NR>1{print $2","$1","0","$5","$7","$8","$9","0","0","0","0","0","0}' $baseFolder/$fileSS$dateDwl.csv > $file1


#----------- Processing SO File
/usr/bin/unzip $baseFolder/$fileSO$dateDwl.zip -d $baseFolder > /dev/null
/usr/bin/rm $baseFolder/$fileSO$dateDwl.zip
/usr/bin/mv $baseFolder/$fileSO$dateDwl.DBF $baseFolder/$fileSO$dateDwl.dbf
$dbf2csv $baseFolder/$fileSO$dateDwl.dbf
/usr/bin/rm $baseFolder/$fileSO$dateDwl.dbf

#------------------ Open Stock
awk -F',' 'NR>1{print $2","$1","$4}' $baseFolder/$fileSO$dateDwl.csv > $file2


#----------- Processing FI File
/usr/bin/unzip $baseFolder/$fileFI$dateDwl.zip -d $baseFolder > /dev/null
/usr/bin/rm $baseFolder/$fileFI$dateDwl.zip
/usr/bin/mv $baseFolder/$fileFI$dateDwl.DBF $baseFolder/$fileFI$dateDwl.dbf
$dbf2csv $baseFolder/$fileFI$dateDwl.dbf
/usr/bin/rm $baseFolder/$fileFI$dateDwl.dbf

#------------------ NBSA Stock
awk -F',' 'NR>1{print $1",""'$fullDt'"","$5","$6}' $baseFolder/$fileFI$dateDwl.csv > $file3


#----------- Processing SQ/Freq File
/usr/bin/cp $baseFolder/$fileSQ$dateDwl.TXT $baseFolder/insert/stockTrxFreq.txt
/usr/bin/sed -e '1,12d' $d < $file4 > $baseFolder/insert/stockTrxFreq_1.txt && /usr/bin/rm $baseFolder/insert/stockTrxFreq.txt
/usr/bin/awk '{print substr($0,7,4)","substr($0,126,7)}' $baseFolder/insert/stockTrxFreq_1.txt > $baseFolder/insert/stockTrxFreq.txt && /usr/bin/rm $baseFolder/insert/stockTrxFreq_1.txt
/usr/bin/sed 's/ //g' $baseFolder/insert/stockTrxFreq.txt > $baseFolder/insert/stockTrxFreq_1.txt &&  /usr/bin/rm $baseFolder/insert/stockTrxFreq.txt
head -n -2 $baseFolder/insert/stockTrxFreq_1.txt > $baseFolder/insert/stockTrxFreq.txt && /usr/bin/rm $baseFolder/insert/stockTrxFreq_1.txt
awk -F',' '{print $1",""'$fullDt'"","$2}' $baseFolder/insert/stockTrxFreq.txt > $baseFolder/insert/stockTrxFreq_1.txt 
/usr/bin/mv $baseFolder/insert/stockTrxFreq_1.txt $baseFolder/insert/stockTrxFreq.txt
#&& /usr/bin/rm $file4 && /usr/bin/mv $tempFile4 $file4

#----------- List file
ls -l $baseFolder && ls -l $baseFolder/insert
