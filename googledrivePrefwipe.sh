#!/bin/bash

## this script finds, removes, and reinstalls Drive for Desktop settings for easier resets. Needs Sudo##
find $HOME/LibraryCookies $HOME/Library/Application\ Scripts $HOME/Library/Preferences $HOME/Library/Group\ Containers -iname "*google*drive*" -delete
rm -r $HOME/Library/Group\ Containers/google_drive
rm -r $HOME/Library/Application\ Support/Google/DriveFS
sudo rm -r /Applications/Google\ Drive/

# gets latest version of Google Drive
curl https://dl.google.com/drive-file-stream/GoogleDrive.dmg -o /Users/Shared/GoogleDrive.dmg

# installs latest version
hdiutil mount /Users/Shared/GoogleDrive.dmg; sudo installer -pkg /Volumes/Install\ Google\ Drive/GoogleDrive.pkg -target "/Volumes/Macintosh HD" && hdiutil unmount /Volumes/Install\ Google\ Drive/
echo "Google Drive has been installed"
mv /Users/Shared/GoogleDrive.dmg $USER/.Trash
