#!/bin/bash
set +e

hasJestConfig=$(jq -r 'has("jest")' package.json)

if [[ ${hasJestConfig} == true ]]; then
    JEST_OPTS=""
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
fi

if [ -f ./test/spec/support/jasmine-runner.js ]; then
    export BABEL_ENV=specs
    node ./test/spec/support/jasmine-runner.js
fi
