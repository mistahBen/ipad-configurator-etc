#!/bin/bash
## must be run as root
## note that if you use a different mobileconfig, the identifier will need to be changed as well.
# You can find this in the mobileconfig if you view in textedit.
mobileconfig=studentwifinew.mobileconfig
ident=4AE76AF5-074A-4798-AF0D-38692BC1A98B

if [ "$EUID" -ne 0 ] # check for sudo/root
  then echo "Are you root?"
  exit
fi
if [ $(ls | wc -l) -gt 2 ]
	then echo "Please run this command from a directory ONLY containing this script and the mobileconfig file."
	exit 2
fi

jamf removemdmprofile &&
open "x-apple.systempreferences:com.apple.preference.profiles" &&
sleep 10
open $mobileconfig &&
sleep 15
profiles renew -type enrollment
sleep 120 && # wait for enrollment profiles to download
profiles remove -identifier $ident &&
mv $PWD /var/root/.Trash/
