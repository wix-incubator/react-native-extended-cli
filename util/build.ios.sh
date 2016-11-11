#!/bin/bash -e

model=$npm_package_config_iphoneModel
appName=$npm_package_config_appName
scheme=$npm_package_config_appName
buildPath="./DerivedData/${appName}/Build/Products/${appName}-iphonesimulator/${appName}.app"

set +e
rm -rf ./artifacts; mkdir ./artifacts/ ; npm ls > ./artifacts/npm-list.txt
set -e

if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
  rm -rf ${buildPath}
  scheme="Release"
  buildMode="Release"
  # output npmDiff. once npm update isn't required, this should be moved to prebuild
  set +e
  $rnxRoot/util/npmDiff.sh  --buildName=${appName} | head -n 150
  set -e
else
  buildMode="Debug"
fi

cd ios

# build app
$rnxRoot/util/logger.sh blockOpened "XCode Build"
echo Building ${appName} in with scheme: ${scheme}...
#xcodebuild -scheme ${scheme} clean
xcodebuild -scheme ${scheme} build -destination "platform=iOS Simulator,name=${model}"
$rnxRoot/util/logger.sh blockClosed "XCode Build"

# make sure that the bundle was created successfully
if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
  if [ ! -f ./DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app/main.jsbundle ]; then
    echo "jsbundle was not created!" > /dev/stderr
    exit 4
  fi
fi

#TODO detox installs and starts the simulator by its own - this is jasmine/appium specific and should be deprecated eventually
if [ -f "./test/e2e/support/jasmine-runner.js" ]; then
  node "$rnxRoot/util/start-simulator.ios.js"
  CURRENT_BUNDLE_IDENTIFIER=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "./DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app/Info.plist")
  xcrun simctl uninstall booted ${CURRENT_BUNDLE_IDENTIFIER}
  xcrun simctl install booted "./DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app"
fi

cd ..