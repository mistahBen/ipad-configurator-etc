#!/bin/bash

echo "###
iPad wifi & enroll utility

###
"
configPath=studentwifinew.mobileconfig # edit this as needed if it is not in the same directory

cfgutil pair &&
cfgutil -f install-profile "$configPath" &&
#Note: this command always report as failing even if it succeeds.
echo "failure is normal."
sleep 20
cfgutil prepare --dep --skip-language --skip-region &

afplay /System/Library/Sounds/Ping.aiff
