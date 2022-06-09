#!/bin/bash
# A script using configurator command line tools to erase and restore iPads

echo "###
iPad reset script
###
"
configpath=$HOME/Desktop/Configuration\ Profiles/studentwifinew.mobileconfig # edit this as needed

while [ TRUE ] ; do
    read -p "press [ ENTER ] to reset iPads"

    cfgutil -f erase &&
    sleep 5
    read -p "iPad(s) resetting. Press enter when the iPads are back at the welcome screen."
    cfgutil -f install-profile "$configpath" && # Note: this command always report as failing even if it succeeds.
    sleep 30
    cfgutil -f prepare --dep --skip-language --skip-region &&

    afplay /System/Library/Sounds/Ping.aiff
    echo "You may disconnect iPads now. Press [ ENTER ] to configure next iPad(s). To exit, press Ctrl+C."
done
