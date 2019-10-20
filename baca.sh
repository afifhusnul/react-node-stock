#!/bin/bash

baseFolder=/home/msa/www/stock/new/bei-files
file1=$baseFolder/insert/stockTrxIdx.csv
file2=$baseFolder/insert/stockTrxOpen.csv
file3=$baseFolder/insert/stockTrxNbsa.csv
file4=$baseFolder/insert/stockTrxFreq.txt
tempFile4=$baseFolder/insert/stockTrxFreq_1.csv



#read -p "Enter date , Format --> (YYMMDD) : " dateDwl

#fullDt="20"${dateDwl:0:2}"-"${dateDwl:2:2}"-"${dateDwl:4:2}

#------------------ Master Stock
#awk -F',' 'NR>1{print $2","$1","0","$5","$7","$8","$9","0","0","0","0","0","0}' $baseFolder/SS191018.csv > $file1

#------------------ Open Stock
#awk -F',' 'NR>1{print $2","$1","$4}' $baseFolder/SO191018.csv > $file2

#------------------ NBSA Stock
#awk -F',' 'NR>1{print $1",""'$fullDt'"","$5","$6}' $baseFolder/FI191018.csv > $file3

#------------------ Freq Stock
#sed -e '1,12d' $d < $baseFolder/SQ191018.txt > $baseFolder/insert/SQ191018New.txt
sed -e '1,12d' $d < $file4 > $tempFile4
#awk '{print substr($0,7,4)","substr($0,126,7)}' $file4 > $tempFile4
#sed 's/ //g' $tempFile4 > $file4 &&  head -n -2  $file4 > $tempFile4
#/usr/bin/rm $tempFile4
#/usr/bin/rm $file4 &&  /usr/bin/mv $tempFile4 $file4


#------------------- Baru
awk '{print substr($0,7,4)","substr($0,126,7)}' $tempFile4 > $file4
sed 's/ //g' $file4 > $tempFile4 &&  head -n -2  $tempFile4 > $file4
#/usr/bin/rm $tempFile4
#/usr/bin/rm $file4 &&  /usr/bin/mv $tempFile4 $file4


