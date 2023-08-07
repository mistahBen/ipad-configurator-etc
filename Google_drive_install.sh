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

#### Google Drive check and download

checkForBackup=$(find /Applications/*Backup*)

user_folders =$(ls /Users | grep -ve ladmin -e Shared -e Library)

if  [[ $checkForBackup  ]] ;
    then
      rm -r /Applications/*Backup*
      for user in $user_folders
      do
        rm -r /$user/Library/Application\ Support/Google/Drive*
        rm /$user/Library/Preferences/*google*drive*
      done
      sudo curl https://dl.google.com/drive-file-stream/GoogleDrive.dmg -o /Users/Shared/GoogleDrive.dmg &&
      hdiutil mount GoogleDrive.dmg; sudo installer -pkg /Volumes/Install\ Google\ Drive/GoogleDrive.pkg -target "/Volumes/Macintosh HD"; hdiutil unmount /Volumes/Install\ Google\ Drive/



echo "This script will install a temporary wifi configuration in order to maintain wifi connection for enrollment, complete approval of the mobileconfig file now."

mobileconfig=$(find *wifi*mobileconfig) # searches for any mobileconfig with wifi in the title.
consoleuser=$(stat -f%Su /dev/console)

if [ "$EUID" -ne 0 ] # check for sudo/root
  then echo "Are you root?"
  exit
fi


## remove old mdm profiles
read -p "Press Enter to proceed to check enrollment"

checkEnrollment=$(/usr/bin/profiles status -type enrollment -verbose | grep No)

if [[ $checkEnrollment ]];
  then
    echo "MDM profiles are showing as invalid. Initiating re-enrollment."

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
    profiles remove -identifier $ident -user $consoleuser
    # mv $PWD /var/root/.Trash/ # trash this script and mobileconfig
fi
exit


# google drive installer credit source: https://support.google.com/a/answer/7491144?hl=en&ref_topic=7455083#zippy=%2Cmac