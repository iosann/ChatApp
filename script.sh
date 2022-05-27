#!/usr/bin/env zsh

xcodebuild clean test -scheme "ChatApp" -destination "platform=iOS Simulator,name=iPhone 11,OS=15.4"
