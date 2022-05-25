#!/bin/bash
#############
# D65 MDM renew script
#############
## MUST RUN AS ROOT
## note that if you use a different mobileconfig, the identifier will need to be changed as well.
# You can find this in the mobileconfig if you view in textedit.
mobileconfig=studentwifinew.mobileconfig
ident="4AE76AF5-074A-4798-AF0D-38692BC1A98B"

if [ "$EUID" -ne 0 ] # check for sudo/root
  then echo "Are you root?"
  exit
fi

echo "This script will install a temporary wifi configuration in order to maintain wifi connection for enrollment, complete approval of the mobileconfig file now."
open $mobileconfig &&
read -p "Press enter to continue enrollment"
jamf removemdmprofile &&
echo "Removing MDM profiles..."
osascript -e 'display notification "Please go to Profiles in System Preferences" with title "MDM Enrollment"'
open "x-apple.systempreferences:com.apple.preference.profiles" &&
sleep 10
profiles renew -type enrollment &&
sleep 120 && # wait for enrollment profiles to download
while [ $(profiles list | wc -l) -lt 3 ] ; do # wait for profiles to actually start installing
  sleep 5
done
profiles remove -identifier $ident
# mv $PWD /var/root/.Trash/ # trash this script and mobileconfig
echo "Please wait for Jamf recon to complete"
jamf recon