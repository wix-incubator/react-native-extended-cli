#!/bin/bash
set -e

function killProcess {
  echo "Killing processes with name ${1}"
  pkill -f "${1}" || true
  echo "--------------------------------"
}

if [ "$1" != "e2e" ]; then
  BABEL_ENV=specs node ./test/spec/support/jasmine-runner.js
fi

killProcess appium

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then
  killProcess inbox-mock-server
  #killProcess fake-server # kill other fake servers in the CI to clear port 3000
  #nohup node ./node_modules/inbox-mock-server/ &
else
  # disconnect hardware keyboard from simulator
  osascript ${BASH_SOURCE[0]%/*}/set_hardware_keyboard.applescript 0
fi

echo "##teamcity[blockOpened name='E2E']"
set +e
BABEL_ENV=specs specFilterString=./test/e2e/*.e2e.spec.js node ./test/e2e/support/jasmine-runner.js
exitCode=$?
set -e
echo "##teamcity[blockClosed name='E2E']"

if [ "${IS_BUILD_AGENT}" == true ]; then
  killProcess inbox-mock-server
  killProcess inbox-mobile/node_modules/react-native/packager/launchPackager.command
  killProcess "appium"
  killProcess "Simulator"
  killProcess "instruments -t"
  killProcess "CoreSimulator"
fi

exit ${exitCode}
