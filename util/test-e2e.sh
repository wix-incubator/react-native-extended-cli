#!/bin/bash

$rnxRoot/util/logger.sh blockOpened E2E
set +e

hasDebugConfig=$(jq -r '.detox.configurations | has("ios.sim.debug")' package.json)
hasReleaseConfig=$(jq -r '.detox.configurations | has("ios.sim.release")' package.json)

if [[ ${hasDebugConfig} == true ]]; then
   config=ios.sim.debug
fi #otherwise use default

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then
  if [[ ${hasReleaseConfig} == true ]]; then
    config=ios.sim.release
  fi #otherwise use default

  $rnxRoot/util/checkPort.sh 3000
  $rnxRoot/util/killProcess.sh fake-server # kill other fake servers in the CI to clear port 3000
  npm run fake-server &
fi

echo "Running Detox tests..."

detoxVersion=$(jq -r .devDependencies.detox package.json)
if [[ ${detoxVersion:0:2} == *"5"* ]]; then
  ./node_modules/.bin/detox test --configuration ${config}
else
  echo "Please upgrade to detox@5.x.x, support for other versions in rnx will be soon deprecated"
  $rnxRoot/util/killProcess.sh detox-server
  ./node_modules/.bin/detox-server &
  BABEL_ENV=specs mocha test/e2e --opts ./test/e2e/mocha.opts $@
fi

exitCode=$?

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then
  $rnxRoot/util/logger.sh blockOpened "Simulator Diagnostic Logs"
  lastSimulator=`ls -Art /Users/builduser/Library/Logs/CoreSimulator/ |tail -n 1`
  cat /Users/builduser/Library/Logs/CoreSimulator/${lastSimulator}/system.log  |tail -n 2000
  $rnxRoot/util/logger.sh blockClosed "Simulator Diagnostic Logs"
fi

set -e

if [ "${IS_BUILD_AGENT}" == true ]; then
  $rnxRoot/util/killProcess.sh ./node_modules/react-native/packager/launchPackager.command
  $rnxRoot/util/killProcess.sh "Simulator"
  $rnxRoot/util/killProcess.sh "CoreSimulator"
  $rnxRoot/util/killProcess.sh "fake-server"
fi

$rnxRoot/util/postTest.sh

$rnxRoot/util/logger.sh blockClosed E2E

exit ${exitCode}
