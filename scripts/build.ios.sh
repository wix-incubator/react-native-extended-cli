#!/bin/bash -e

model=$npm_package_config_iphoneModel
appName=$npm_package_config_appName
scheme=$npm_package_config_appName
buildPath="./DerivedData/${appName}/Build/Products/${appName}-iphonesimulator/${appName}.app"

rm -rf ./artifacts; mkdir ./artifacts/ ; npm ls > ./artifacts/npm-list.txt

if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
  rm -rf ${buildPath}
  scheme="Release"
  buildMode='Release'
  # output npmDiff. once npm update isn't required, this should be moved to prebuild
  set +e
  $rnxRoot/scripts/npmDiff.sh  --buildName=${appName} | head -n 150
  set -e
else
  buildMode='Debug'
fi

if [ ! -f ./test/e2e/mocks/configuration-facade-mocks.private.js ]; then
  echo "export const ConfigurationFacadeMockPrivate = {};" > ./test/e2e/mocks/configuration-facade-mocks.private.js
fi

cd ios

# build app
echo "##teamcity[blockOpened name='XCode Build']"
echo Building ${appName} in with scheme: ${scheme}...
#xcodebuild -scheme ${scheme} clean
xcodebuild -scheme ${scheme} build -destination "platform=iOS Simulator,name=${model}"
echo "##teamcity[blockClosed name='XCode Build']"

# make sure that the bundle was created successfully
if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
  if [ ! -f ./DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app/main.jsbundle ]; then
    echo "jsbundle was not created!" > /dev/stderr
    exit 4
  fi
fi

node "${BASH_SOURCE[0]%/*}/start-simulator.ios.js"

# install app
CURRENT_BUNDLE_IDENTIFIER=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "./DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app/Info.plist")
xcrun simctl uninstall booted ${CURRENT_BUNDLE_IDENTIFIER}
xcrun simctl install booted "./DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app"

cd ..