#!/bin/bash

## this script finds, removes, and reinstalls Drive for Desktop settings for easier resets. Needs Sudo##

loggedinuser=$(stat -f %Su /dev/console)

find $loggedinuser/Library/Cookies $loggedinuser/Library/Application\ Scripts $loggedinuser/Library/Preferences $loggedinuser/Library/Group\ Containers -iname "*google*drive*" -delete
rm -r $loggedinuser/Library/Group\ Containers/google_drive
rm -r $loggedinuser/Library/Application\ Support/Google/DriveFS

sudo rm -r /Applications/Google\ Drive.app/
# gets latest version of Google Drive
curl https://dl.google.com/drive-file-stream/GoogleDrive.dmg -o /Users/Shared/GoogleDrive.dmg

# installs latest version
hdiutil mount /Users/Shared/GoogleDrive.dmg; sudo installer -pkg /Volumes/Install\ Google\ Drive/GoogleDrive.pkg -target "/Volumes/Macintosh HD" && hdiutil unmount /Volumes/Install\ Google\ Drive/
echo "Google Drive has been installed"
mv /Users/Shared/GoogleDrive.dmg $USER/.Trash
