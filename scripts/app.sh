#!/bin/bash
buildMode="Debug"
appName=$npm_package_config_appName
packageName=$1
appPath=./ios/DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app

echo "Starting ${appName} in ${buildMode} mode"
node "../scripts/start-simulator.ios.js"

# install app
CURRENT_BUNDLE_IDENTIFIER=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$appPath/Info.plist")
xcrun simctl uninstall booted ${CURRENT_BUNDLE_IDENTIFIER}
xcrun simctl install booted "$appPath"
xcrun simctl launch booted $packageName
