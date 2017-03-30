#!/bin/bash
set -e

#this is a deprecated hack. We'll remove it when dependencies aren't doing this kind of ugly magic.
# for now it stays
if [ -f ./src/facades/mocks.js ]; then
  if [ "${IS_BUILD_AGENT}" == true ] || [ "$1" == 'release' ]; then
    # overwrite mocks.js as e2e/ is npm ignored and otherwise the packager of the containing object will red screen
    echo "export default {};" > ./src/facades/mocks.js
  fi
fi