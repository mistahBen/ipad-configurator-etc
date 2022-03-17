#!/bin/bash

eList="configlist.csv"

if [[ cfgutil get ECID | grep configlist.csv ]];
  then
    serials=$(cfgutil get serialNumber)
    cfgutil -f install-profile "$configpath" && # Note: this command always report as failing even if it succeeds.
    sleep 30
    cfgutil -f prepare --dep --skip-language --skip-region
    afplay /System/Library/Sounds/Ping.aiff
    echo "$serials,$(date "+%Y-%m-%d_%H:%M:%S")" >> reconfiged.csv # logs device config date. Optional but handy.
    echo "You may disconnect iPads now. Press [ ENTER ] to configure next iPad(s)."
  else
    cfgutil pair
    echo "Confirm trust on connected device."
    cfgutil get ECID >> $eList
    sleep 20
    cfgutil erase
