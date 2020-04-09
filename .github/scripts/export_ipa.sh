#!/bin/bash

set -eo pipefail
cd hICNTools
xcodebuild -archivePath $PWD/build/hICNTools.xcarchive \
            -exportOptionsPlist exportOptions.plist \
            -exportPath $PWD/build \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
