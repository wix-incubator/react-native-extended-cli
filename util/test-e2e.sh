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

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then
  echo "[]" > ~/Library/Detox/device.registry.state.lock
  detox test --configuration ${config} --runner-config test/e2e/${mochaFile} --artifacts-location "artifacts/" --record-logs failing --take-screenshots failing
else
  detox test --configuration ${config} --runner-config test/e2e/${mochaFile}
fi

exitCode=$?

if [ "${IS_BUILD_AGENT}" == true ]; then
  # Move artifacts folder one level up so it will be collected
  ARTIFACTS_FOLDER="./artifacts"
  mkdir $ARTIFACTS_FOLDER
  cp ./package-lock.json $ARTIFACTS_FOLDER
  mv $ARTIFACTS_FOLDER ../
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
