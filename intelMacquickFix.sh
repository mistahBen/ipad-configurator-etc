#!/bin/bash
#############
# D65 Intel Macbook pre-migration 'quick-fix'
# for making sure that Google Drive, MDM enrollment is accurate, and that things are otherwise good to go for migration
#############
## MUST RUN AS ROOT!!!
## note that if you use a different mobileconfig, the identifier will need to be changed as well.
# You can find this in the mobileconfig if you view in textedit.

if [ "$EUID" -ne 0 ] # check for sudo/root
  then echo "Are you root?"
  exit
fi


mobileconfig=studentwifinew.mobileconfig
ident="4AE76AF5-074A-4798-AF0D-38692BC1A98B"
consoleuser=$(stat -f%Su /dev/console)

#### Google Drive check and download

checkForBackup=$(find /Applications/*Backup*)

if  [[ $checkForBackup  ]] ;
    then
        rm -r *Backup*
        sudo curl https://dl.google.com/drive-file-stream/GoogleDrive.dmg -o /Users/Shared/GoogleDrive.dmg &&
        hdiutil mount GoogleDrive.dmg; sudo installer -pkg /Volumes/Install\ Google\ Drive/GoogleDrive.pkg -target "/Volumes/Macintosh HD"; hdiutil unmount /Volumes/Install\ Google\ Drive/
fi

### check for invalid configprofiles

if [[ $(sudo /usr/bin/profiles status -type enrollment -verbose | grep No) ]] ;
    read - p "It looks like there are invalid mobile configuration profiles. Do you want to re-enroll this computer?" yesno
    if [[ $yesno =~ "[Yy]"]] ; then

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
        until [[ $(networksetup -getairportnetwork en0 | grep D65-Staff) ]] ; do
            sleep 2.5
        done
    fi

fi


if [ "$EUID" -ne 0 ] # check for sudo/root
  then echo "Are you root?"
  exit
fi


#malwarebytes remover

sudo kill $(ps aux | grep Malware | awk '{printf $2" "}')
/Library/LaunchDaemons/com.malware*

rm -r/Library/Application\ Support/MalwareBytes/

rm -r /Applications/Malwarebytes.app/


profiles remove -identifier $ident -user $consoleuser
# mv $PWD /var/root/.Trash/ # trash this script and mobileconfig
exit


# google drive installer credit source: https://support.google.com/a/answer/7491144?hl=en&ref_topic=7455083#zippy=%2Cmac