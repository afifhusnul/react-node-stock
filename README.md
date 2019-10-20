# React-node-stock tools

This is my tool to download stock info file from http://www.idxdata.co.id/
These tools was developed with NodeJS as backend and ReactJS as front end
There are 4 files need to be downloaded, please refer to file `goDownload.sh`
 - SSYYMMDD.zip
 - SOYYMMDD.zip
 - FIYYMMDD.zip
 - SQYYMMDD.TXT

After downloaded those zip file need to extract and convert into csv file to be able to load into postgresql table

To convert DBF to csv need to download `https://gist.github.com/bertspaan/8220892`
