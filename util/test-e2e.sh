#!/bin/bash

$rnxRoot/util/killProcess.sh appium

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then  
  $rnxRoot/util/killProcess.sh fake-server # kill other fake servers in the CI to clear port 3000
  nohup npm run fake-server &
else
  # disconnect hardware keyboard from simulator
  osascript $rnxRoot/util/set_hardware_keyboard.applescript 0
fi

echo "##teamcity[blockOpened name='E2E']"
set +e
BABEL_ENV=specs specFilterString=./test/e2e/*.e2e.spec.js node ./test/e2e/support/jasmine-runner.js
exitCode=$?
set -e
echo "##teamcity[blockClosed name='E2E']"

if [ "${IS_BUILD_AGENT}" == true ]; then
  $rnxRoot/util/killProcess.sh inbox-mock-server
  $rnxRoot/util/killProcess.sh inbox-mobile/node_modules/react-native/packager/launchPackager.command
  $rnxRoot/util/killProcess.sh "appium"
  $rnxRoot/util/killProcess.sh "Simulator"
  $rnxRoot/util/killProcess.sh "instruments -t"
  $rnxRoot/util/killProcess.sh "CoreSimulator"
fi

$rnxRoot/util/postTest.sh

exit ${exitCode}
