#!/bin/bash
buildMode="Debug"
appName=$npm_package_config_appName
packageName=$npm_package_config_packageName
appPath=./ios/DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app

echo "Starting ${appName} in ${buildMode} mode"
node "$rnxRoot/util/start-simulator.ios.js" $npm_package_config_iphoneModel

# install app
CURRENT_BUNDLE_IDENTIFIER=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$appPath/Info.plist")
xcrun simctl uninstall booted ${CURRENT_BUNDLE_IDENTIFIER}
xcrun simctl install booted "$appPath"
xcrun simctl launch booted $packageName
