#!/bin/bash
# A script using configurator command line tools to erase and restore iPads.
# script erases iPads, pushes wifi profile and activates but does not prepare or enroll in DEP.

echo "###
iPad reset script
###
"
configpath=$HOME/Desktop/Configuration\ Profiles/studentwifinew.mobileconfig # edit this as needed

while [ TRUE ] ; do
    read -p "press [ ENTER ] to reset iPads"
    cfgutil -f pair &&
    echo $(cfgutil -f get serialNumber) >> ipadlog.csv &&
    cfgutil -f erase &&
    sleep 5
    read -p "iPad(s) resetting. Press enter when the iPads are back at the welcome screen."
    cfgutil -f install-profile "$configpath" && # Note: this command always report as failing even if it succeeds.
    sleep 30
    cfgutil -f activate
    afplay /System/Library/Sounds/Ping.aiff
    echo "You may disconnect iPads now. Press [ ENTER ] to configure next iPad(s). To exit, press Ctrl+C."
done
