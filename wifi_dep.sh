#!/bin/bash
#edit this line to the path of your wifi config profile
#wifiProf="Users/alexanderb/Desktop/Configuration Profiles/Student Wi-Fi new.mobileconfig"
echo "###
iPad wifi & enroll utility

###
"
configpath=$HOME/Desktop/Configuration\ Profiles/studentwifinew.mobileconfig # edit this as needed

cfgutil pair &&
#Note: this command always report as failing even if it succeeds.
cfgutil -f install-profile "$configpath" &&
proc = $($!) # get PID of the cfgutil command
echo "failure is normal."
sleep 10
cfgutil prepare --dep --skip-language --skip-region &&
sleep 10

afplay /System/Library/Sounds/Ping.aiff
if [ -z "$1" ]
    then kill proc
