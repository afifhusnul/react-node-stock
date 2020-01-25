#!/bin/bash

dateDwl=$1
#----------- Use it later to add date into csv files
fullDt="20"${dateDwl:0:2}"-"${dateDwl:2:2}"-"${dateDwl:4:2}

echo $fullDt

