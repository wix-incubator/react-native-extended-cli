#!/bin/bash

$rnxRoot/util/logger.sh blockOpened E2E 
set +e

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then  
  $rnxRoot/util/killProcess.sh fake-server # kill other fake servers in the CI to clear port 3000
  nohup npm run fake-server &
else
  # disconnect hardware keyboard from simulator
  osascript $rnxRoot/util/set_hardware_keyboard.applescript 0
fi

#todo deprecate jasmine/appium support eventually
if [ -f "./test/e2e/support/jasmine-runner.js" ]; then
  $rnxRoot/util/killProcess.sh appium  
  BABEL_ENV=specs specFilterString=./test/e2e/*.e2e.spec.js node ./test/e2e/support/jasmine-runner.js
else 
  $rnxRoot/util/killProcess.sh detox-server
  ./node_modules/.bin/detox-server &
  BABEL_ENV=specs mocha test/e2e --opts ./test/e2e/mocha.opts
fi

exitCode=$?
set -e
$rnxRoot/util/logger.sh blockClosed E2E 

if [ "${IS_BUILD_AGENT}" == true ]; then  
  $rnxRoot/util/killProcess.sh ./node_modules/react-native/packager/launchPackager.command
  $rnxRoot/util/killProcess.sh "appium"
  $rnxRoot/util/killProcess.sh "Simulator"
  $rnxRoot/util/killProcess.sh "instruments -t"
  $rnxRoot/util/killProcess.sh "CoreSimulator"
fi

$rnxRoot/util/postTest.sh

exit ${exitCode}
