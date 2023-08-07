#!/bin/bash

## Script for gathering asset and serial numbers in sequence.
## requirements: MacOS and Configurator command line tools must be installed.

echo "Asset tag and serial number listbuilder. 
Be sure only one iOS device is connected at a time."

read -p "File name: " fileName
outFile="$fileName.csv"

while [ TRUE ] ; do
    read -p "Asset tag: " Asset
    serial=$(cfgutil get serialNumber)
    if ! [ $serial ] ; then
        echo "unable to find serial number. Try again."
        else
            echo "$Asset, $serial" >> $outFile
    fi
done