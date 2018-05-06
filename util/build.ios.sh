#!/bin/bash -e

if [[ "${USE_ENGINE}" == true ]]; then 
  detox build -c ios.sim.release
else 

  model=$npm_package_config_iphoneModel
  appName=$npm_package_config_appName
  scheme=$npm_package_config_appName
  releaseScheme=${npm_package_config_releaseScheme:=Release}

  # update vars based on build mode
  if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
    scheme="${releaseScheme}"
    buildMode="${releaseScheme}"
    export RCT_NO_LAUNCH_PACKAGER=true
  else
    buildMode="Debug"
  fi

  # set and clean build path
  buildPath="./DerivedData/${appName}/Build/Products/${scheme}-iphonesimulator/${appName}.app"
  cd ios

  # build app
  $rnxRoot/util/logger.sh blockOpened "XCode Build"
  echo Building ${appName} in with scheme: ${scheme}...
  #xcodebuild -scheme ${scheme} clean
  xcodebuild -scheme ${scheme} build -destination "platform=iOS Simulator,name=${model}"
  $rnxRoot/util/logger.sh blockClosed "XCode Build"

  # make sure that the bundle was created successfully
  if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
    if [ ! -f ${buildPath}/main.jsbundle ]; then
      echo "error: main.jsbundle was not created in ${buildPath}/main.jsbundle" > /dev/stderr
      exit 4
    fi
  fi

  cd ..
fi 
