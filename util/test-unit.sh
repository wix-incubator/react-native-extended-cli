#!/bin/bash
set +e

hasJestConfig=$(jq -r 'has("jest")' package.json)

if [[ $* != *--skip-jest* ]]; then
  if [[ ${hasJestConfig} == true ]]; then
      JEST_OPTS=""

      $rnxRoot/util/logger.sh blockOpened "Jest Tests"

      if [[ $* == *--jest-watch* ]]; then
          JEST_OPTS="$JEST_OPTS --watch"
      fi

      [ -z "$TEAMCITY_VERSION" ] || {
          JEST_OPTS="$JEST_OPTS -i --coverage"
      }
      CI=true jest $JEST_OPTS
      if [ $? -ne 0 ]; then
          exit 1
      fi

      $rnxRoot/util/logger.sh blockClosed "Jest Tests"
  fi
fi

if [ -f ./test/spec/support/jasmine-runner.js ]; then

    $rnxRoot/util/logger.sh blockOpened "Jasmine Tests"

    export BABEL_ENV=specs
    ls -ltr
    if [ -f ./node_modules/ts-node/dist/index.js ]; then
      ts-node ./test/spec/support/jasmine-runner.js
    else
      node ./test/spec/support/jasmine-runner.js
    fi

    $rnxRoot/util/logger.sh blockOpened "Jasmine Tests"
fi
