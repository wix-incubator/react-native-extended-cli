#!/bin/bash

if [[ $* == *--help* ]]; then
    echo "
    rnx app --> help 
    ##########################
    # Runs native apps without building or testing anything first. Fastest way to get a
    # simulator/emulator running with the demo app
    # Options: 
    #  android 
    #  ios
    #  
    # Examples: 
    # $> rnx app ios
    # $> rnx app android
    #########################
"
    exit 0
fi

if [ "$1" != "android" ]; then
  
  node "$rnxRoot/util/start-simulator.ios.js" $npm_package_config_iphoneModel
  
  if [[ "${USE_ENGINE}" == true ]]; then 
    one-app-engine -i --no-packager --no-mock-server
  else 
    buildMode="Debug"
    appName=$npm_package_config_appName
    packageName=$npm_package_config_packageName
    appPath=./ios/DerivedData/${appName}/Build/Products/${buildMode}-iphonesimulator/${appName}.app

    echo "Starting ${appName} in ${buildMode} mode"
    
    # install app
    CURRENT_BUNDLE_IDENTIFIER=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$appPath/Info.plist")
    xcrun simctl uninstall booted ${CURRENT_BUNDLE_IDENTIFIER}
    xcrun simctl install booted "$appPath"
    xcrun simctl launch booted $packageName

  fi

fi

if [ "$1" != "ios" ]; then
  echo "Starting emulator..."
  $ANDROID_HOME/tools/emulator -avd 'NEXUS_5X_API_23' &

  WAIT_CMD="adb wait-for-device shell getprop init.svc.bootanim"
  until $WAIT_CMD | grep -m 1 stopped; do
    printf "."
    sleep 0.1
  done
  echo 'Emulator started...'

  firstDevice=$(adb devices | tail -n +2 | awk '{print $1}')
  adb -s $firstDevice install -r  android/app/build/outputs/apk/app-debug.apk
  adb shell monkey -p com.mobile -c android.intent.category.LAUNCHER 1

fi