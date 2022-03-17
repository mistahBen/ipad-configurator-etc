#!/bin/bash

echo "###
iPad wifi & enroll utility

###
"
configpath=studentwifinew.mobileconfig # edit this as needed if it is not in the same directory

cfgutil pair &&
cfgutil -f install-profile "$configpath" &&
#Note: this command always report as failing even if it succeeds.
echo "failure is normal."
sleep 10
cfgutil prepare --dep --skip-language --skip-region &

afplay /System/Library/Sounds/Ping.aiff
