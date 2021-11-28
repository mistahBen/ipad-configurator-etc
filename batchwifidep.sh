#!/bin/bash
# You can connect as many iPads as you need via USB when running this script. It will allow you to quickly connect iPads, enroll them, and then you can disconnect them hitting enter when you're ready to enroll the next batch.
#
# Do not use with cfgutil exec -a command as it will continually fail.
#
# Make this an alias by adding the following to your .bashrc or .zshrc file:
# alias cfgprofile="~/path/to/file/batchwifidep.sh"
echo "###
iPad wifi & enroll utility

###
"
configpath=$HOME/Desktop/Configuration\ Profiles/studentwifinew.mobileconfig # edit this as needed

while [ TRUE ] ; do
read -p "press [ ENTER ] to run configuration"
devicecount = $(cfgutil list | wc -l)
cfgutil -f pair
if [ "$devicecount" > 1 ] ; then
    #serial number logging, if you're into that
    serials=$(cfgutil -f get serialNumber | awk '{print $4}')
    else
        serials=$(cfgutil get serialNumber)

cfgutil -f install-profile "$configpath" && # Note: this command always report as failing even if it succeeds.
sleep 30
cfgutil -f prepare --dep --skip-language --skip-region &&
echo "$serials,$(date "+%Y-%m-%d_%H:%M:%S")" >> serialsconfig.csv # logs device config date. Optional but handy.
afplay /System/Library/Sounds/Ping.aiff
echo "You may disconnect iPads now. Press [ ENTER ] to configure next iPad(s)."
done
