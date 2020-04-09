#!/bin/bash

set -eo pipefail
cd hICNTools
xcrun altool --upload-app -t ios -f build/hICNTools.ipa -u "$APPLEID_USERNAME" -p "$APPLEID_PASSWORD" --verbose
