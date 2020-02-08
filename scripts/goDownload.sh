#!/bin/bash
#setproxy

#--------- Define today's date
todayDt=`date '+%y%m%d'`

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
dbf2csv=/home/msa/www/stock/new/scripts/dbf2csv.py
loadData=/home/msa/www/stock/new/scripts/loadPg.sh
genAmibroker=/home/msa/www/stock/new/scripts/genAmibroker.sh
baseFolder=/home/msa/www/stock/new/bei-files

fileMasterStock=$baseFolder/insert/stockMaster.csv
file1=$baseFolder/insert/stockTrxIdx.csv
file2=$baseFolder/insert/stockTrxOpen.csv
file3=$baseFolder/insert/stockTrxNbsa.csv
file4=$baseFolder/insert/stockTrxFreq.txt
tempfile4=$baseFolder/insert/stockTrxFreq_1.txt
/usr/bin/rm $baseFolder/siap.txt && /usr/bin/rm $baseFolder/S* && /usr/bin/rm $baseFolder/F*
/usr/bin/rm $file1 $file2 $file3 $file4 $tempFile4

#----------- Get input date to download data (format YYYY-MM-DD)
#read -p "Enter date , Format --> (YYMMDD) : " dateDwl
dateDwl=$todayDt

#----------- Use it later to add date into csv files
fullDt="20"${dateDwl:0:2}"-"${dateDwl:2:2}"-"${dateDwl:4:2}

#----------- Start download files

echo $baseUrl/$dwl_1$dateDwl.zip >> $baseFolder/siap.txt
echo $baseUrl/$dwl_2$dateDwl.zip >> $baseFolder/siap.txt
echo $baseUrl/$dwl_3$dateDwl.zip >> $baseFolder/siap.txt
echo $baseUrl/$dwl_4$dateDwl.TXT >> $baseFolder/siap.txt

#---------- Function check file on host
#function validateUrl(){
#  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true"; fi
#}

#----------- Download file in bulk

if wget -S --spider $baseUrl/$dwl_1$dateDwl.zip 2>&1 | grep -q 'Remote file exists and could contain further links'; then
    echo "Url $baseUrl/$dwl_1$dateDwl.zip does not exist!"
else
    echo "Found $baseUrl/$dwl_1$dateDwl.zip, going to fetch it"
    wget -i $baseFolder/siap.txt -P $baseFolder

	#----------- Processing SS File
	/usr/bin/unzip $baseFolder/$fileSS$dateDwl.zip -d $baseFolder > /dev/null
	/usr/bin/rm $baseFolder/$fileSS$dateDwl.zip
	/usr/bin/mv $baseFolder/$fileSS$dateDwl.DBF $baseFolder/$fileSS$dateDwl.dbf
	$dbf2csv $baseFolder/$fileSS$dateDwl.dbf
	/usr/bin/rm $baseFolder/$fileSS$dateDwl.dbf
	#------------------ Master Stock
	/usr/bin/awk -F',' 'NR>1{print $2","$3}' $baseFolder/$fileSS$dateDwl.csv > $fileMasterStock
	/usr/bin/awk -F',' 'NR>1{print $2","$1","0","$5","$6","$7","$8","$9","0","0","0","0}' $baseFolder/$fileSS$dateDwl.csv > $file1
	/usr/bin/sed 's/\.0//g' $file1 > $baseFolder/insert/myFile.txt
	/usr/bin/cat $baseFolder/insert/myFile.txt > $file1


	#----------- Processing SO File
	/usr/bin/unzip $baseFolder/$fileSO$dateDwl.zip -d $baseFolder > /dev/null
	/usr/bin/rm $baseFolder/$fileSO$dateDwl.zip
	/usr/bin/mv $baseFolder/$fileSO$dateDwl.DBF $baseFolder/$fileSO$dateDwl.dbf
	$dbf2csv $baseFolder/$fileSO$dateDwl.dbf
	/usr/bin/rm $baseFolder/$fileSO$dateDwl.dbf

	#------------------ Open Stock
	/usr/bin/awk -F',' 'NR>1{print $2","$1","$4}' $baseFolder/$fileSO$dateDwl.csv > $file2
	/usr/bin/sed 's/\.0//g' $file2 > $baseFolder/insert/myFile.txt
	/usr/bin/cat $baseFolder/insert/myFile.txt > $file2


	#----------- Processing FI File
	/usr/bin/unzip $baseFolder/$fileFI$dateDwl.zip -d $baseFolder > /dev/null
	/usr/bin/rm $baseFolder/$fileFI$dateDwl.zip
	/usr/bin/mv $baseFolder/$fileFI$dateDwl.DBF $baseFolder/$fileFI$dateDwl.dbf
	$dbf2csv $baseFolder/$fileFI$dateDwl.dbf
	/usr/bin/rm $baseFolder/$fileFI$dateDwl.dbf

	#------------------ NBSA Stock
	/usr/bin/awk -F',' 'NR>1{print $1",""'$fullDt'"","$5","$6}' $baseFolder/$fileFI$dateDwl.csv > $file3
	/usr/bin/sed 's/\.0//g' $file3 > $baseFolder/insert/myFile.txt
	/usr/bin/cat $baseFolder/insert/myFile.txt > $file3
	/usr/bin/rm $baseFolder/insert/myFile.txt


	#----------- Processing SQ/Freq File			
	/usr/bin/cp $baseFolder/$fileSQ$dateDwl.TXT $baseFolder/insert/Freq1.txt
	/usr/bin/sed -e '1,12d' $d < $baseFolder/insert/Freq1.txt > $baseFolder/insert/Freq2.txt
	/usr/bin/awk '{print substr($0,7,7)"|"substr($0,126,7)}' $baseFolder/insert/Freq2.txt > $baseFolder/insert/Freq3.txt
	/usr/bin/sed 's/ //g' $baseFolder/insert/Freq3.txt > $baseFolder/insert/Freq4.txt
	head -n -2 $baseFolder/insert/Freq4.txt > $baseFolder/insert/Freq5.txt
	/usr/bin/awk -F'|' '{print $1"|""'$fullDt'""|"$2}' $baseFolder/insert/Freq5.txt > $baseFolder/insert/Freq6.txt
	/usr/bin/sed 's/,//g' $baseFolder/insert/Freq6.txt > $baseFolder/insert/stockTrxFreq.txt
	/usr/bin/rm $baseFolder/insert/F*.txt

	#----------- List file
	ls -l $baseFolder && ls -l $baseFolder/insert

	#----------- Load Data
	$loadData && $genAmibroker $dateDwl
fi
