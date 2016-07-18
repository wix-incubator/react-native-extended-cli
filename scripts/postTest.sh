#!/bin/bash
set -e

if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
  # overwrite mocks.js as e2e/ is npm ignored and otherwise the packager of the containing object will red screen
  echo "export default {};" > ./src/facades/mocks.js
fi