#!/bin/bash
#############
# D65 MDM renew script
#############
## MUST RUN AS ROOT
## note that if you use a different mobileconfig, the identifier will need to be changed as well.
# You can find this in the mobileconfig if you view in textedit.

mobileconfig=studentwifinew.mobileconfig
ident="4AE76AF5-074A-4798-AF0D-38692BC1A98B"
consoleuser=$(stat -f%Su /dev/console)

if [ "$EUID" -ne 0 ] # check for sudo/root
  then echo "Are you root?"
  exit
fi

echo "This script will install a temporary wifi configuration in order to maintain wifi connection for enrollment, complete approval of the mobileconfig file now."
open $mobileconfig &&
read -p "Press enter to continue enrollment"
echo "Removing MDM profiles..."
jamf removemdmprofile &&
osascript -e 'display notification "Open Profiles in System Preferences, if it does not automatically open" with title "MDM Enrollment"'
open "x-apple.systempreferences:com.apple.preference.profiles" &&
sleep 10
osascript -e 'display notification "Please click Details on the next alert that pops up" with title "MDM Enrollment"' &&
profiles renew -type enrollment &&

until [[ $(sudo profiles list -verbose | grep D65-Staff) ]] ; do # wait for wifi profile to install
  sleep 2.5
done
jamf recon &&
echo "Please connect to the staff wifi network now"
afplay /System/Library/Sounds/Ping.aiff
osascript -e 'display notification "Please connect to the D65-Staff wifi network now" with title "MDM Enrollment"'
until [[ $(networksetup -getairportnetwork en0 | grep D65-Staff)]] ; do
  sleep 2.5
done
profiles remove -identifier $ident -user $consoleuser
# mv $PWD /var/root/.Trash/ # trash this script and mobileconfig
exit