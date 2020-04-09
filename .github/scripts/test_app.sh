#!/bin/bash

set -eo pipefail

cd hICNTools
xcodebuild -workspace hICNTools.xcworkspace \
            -scheme hICNTools \
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 \
            clean test | xcpretty
