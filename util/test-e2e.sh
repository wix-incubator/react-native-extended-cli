#!/bin/bash

$rnxRoot/util/logger.sh blockOpened E2E
set +e

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then
  $rnxRoot/util/checkPort.sh 3000
  $rnxRoot/util/killProcess.sh fake-server # kill other fake servers in the CI to clear port 3000
  npm run fake-server &
else
  # disconnect hardware keyboard from simulator
  osascript $rnxRoot/util/set_hardware_keyboard.applescript 0
fi

echo "Running Detox tests..."
$rnxRoot/util/killProcess.sh detox-server
./node_modules/.bin/detox-server &
BABEL_ENV=specs mocha test/e2e --opts ./test/e2e/mocha.opts $@

exitCode=$?

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then
  $rnxRoot/util/logger.sh blockOpened "Simulator Diagnostic Logs"
  cat `fbsimctl --state=booted diagnose | grep system_log | awk '{print $NF}'`
  $rnxRoot/util/logger.sh blockClosed "Simulator Diagnostic Logs"
fi

set -e
$rnxRoot/util/logger.sh blockClosed E2E

if [ "${IS_BUILD_AGENT}" == true ]; then
  $rnxRoot/util/killProcess.sh ./node_modules/react-native/packager/launchPackager.command
  $rnxRoot/util/killProcess.sh "Simulator"
  $rnxRoot/util/killProcess.sh "instruments -t"
  $rnxRoot/util/killProcess.sh "CoreSimulator"
  $rnxRoot/util/killProcess.sh "fake-server"
fi

$rnxRoot/util/postTest.sh

exit ${exitCode}
