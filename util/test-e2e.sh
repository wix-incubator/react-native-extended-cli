#!/bin/bash
export BABEL_ENV=specs

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

mochaFile="mocha.opts"
if [ "${1}" == "release" ]; then
  rnx start &
elif [ "${IS_BUILD_AGENT}" == true ]; then
  rnx start &
  if [ -f ./test/e2e/mocha-ci.opts ]; then
    mochaFile="mocha-ci.opts"
  fi
fi

detoxVersion=$(jq -r .devDependencies.detox package.json)
if [[ ${detoxVersion:0:2} == *"7"* ]]; then
  mocha test/e2e --configuration  ${config} --opts ./test/e2e/${mochaFile}
elif [[ ${detoxVersion:0:2} == *"6"* ]]; then
  echo "Please upgrade to detox@7.x.x, support for other versions in rnx will be soon deprecated"
  mocha test/e2e --configuration  ${config} --opts ./test/e2e/${mochaFile}
elif [[ ${detoxVersion:0:2} == *"5"* ]]; then
  echo "Please upgrade to detox@7.x.x, support for other versions in rnx will be soon deprecated"
  ./node_modules/.bin/detox test --configuration ${config} --runner-config ${mochaFile}
else
  echo "Please upgrade to detox@7.x.x, support for other versions is deprecated"
  exit 1
fi

exitCode=$?

if [ "${IS_BUILD_AGENT}" == true ]; then
  lastSimulator=`ls -Art $HOME/Library/Developer/CoreSimulator/Devices/ |grep -|tail -n 1`

  $rnxRoot/util/logger.sh blockOpened "Detox Error Logs"
  tail -1000 $HOME/Library/Developer/CoreSimulator/Devices/${lastSimulator}/data/tmp/detox.last_launch_app_log.err
  $rnxRoot/util/logger.sh blockClosed "Detox Error Logs"

  $rnxRoot/util/logger.sh blockOpened "Detox Logs"
  tail -1000 $HOME/Library/Developer/CoreSimulator/Devices/${lastSimulator}/data/tmp/detox.last_launch_app_log.out
  $rnxRoot/util/logger.sh blockClosed "Detox Logs"

  $rnxRoot/util/logger.sh blockOpened "Simulator Diagnostic Logs"
  simulatorLogFile=$HOME/Library/Developer/CoreSimulator/Devices/${lastSimulator}/data/Library/Logs/system.log
  echo "Adding ${simulatorLogFile} to `pwd`/artifacts"
  mkdir ./artifacts
  cp ${simulatorLogFile} ./artifacts/simulator-system.log
  tail -1000 ${simulatorLogFile}
  rm ${simulatorLogFile}
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
