#!/bin/bash

baseFolder=/home/msa/www/stock/new/bei-files
file1=$baseFolder/insert/stockTrxIdx.csv
file2=$baseFolder/insert/stockTrxOpen.csv
file3=$baseFolder/insert/stockTrxNbsa.csv
#file4=$baseFolder/insert/stockTrxFreq.txt
file4=$baseFolder/SQ191028.TXT
tempFile4=$baseFolder/insert/stockTrxFreq_1.csv


 #----------- Processing SQ/Freq File
        /usr/bin/cp $file4 $baseFolder/Freq1.txt
        /usr/bin/sed -e '1,12d' $d < $baseFolder/Freq1.txt > $baseFolder/Freq2.txt
        /usr/bin/awk '{print substr($0,7,7)"|"substr($0,126,7)}' $baseFolder/Freq2.txt > $baseFolder/Freq3.txt
        /usr/bin/sed 's/ //g' $baseFolder/Freq3.txt > $baseFolder/Freq4.txt
        head -n -2 $baseFolder/Freq4.txt > $baseFolder/Freq5.txt
        /usr/bin/awk -F'|' '{print $1"|""'2019-10-28'""|"$2}' $baseFolder/Freq5.txt > $baseFolder/insert/Freq6.txt
		/usr/bin/sed 's/,//g' $baseFolder/insert/Freq6.txt > $baseFolder/insert/Freq7.txt
        #&& /usr/bin/rm $file4 && /usr/bin/mv $tempFile4 $file4

