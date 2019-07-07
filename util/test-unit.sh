#!/bin/bash
set +e

if [[ $* != *--skip-jest* ]]; then
  hasJestConfig=$(jq -r 'has("jest")' package.json)
  if [[ ${hasJestConfig} == true ]]; then
      JEST_OPTS=""

      $rnxRoot/util/logger.sh blockOpened "Jest Tests"

      if [[ $* == *--jest-watch* ]]; then
          JEST_OPTS="$JEST_OPTS --watch"
      fi

      if [ -z "$TEAMCITY_VERSION" ]; then
          jest $JEST_OPTS
      else
          JEST_OPTS="$JEST_OPTS -i --coverage"
          CI=true jest $JEST_OPTS
      fi
      if [ $? -ne 0 ]; then
          exit 1
      fi

      $rnxRoot/util/logger.sh blockClosed "Jest Tests"
  fi
fi

if [ -f ./test/spec/support/jasmine-runner.js ]; then

    $rnxRoot/util/logger.sh blockOpened "Jasmine Tests"

    echo "Jasmine unit tests are deprecated"
    exit 1

    $rnxRoot/util/logger.sh blockOpened "Jasmine Tests"
fi
