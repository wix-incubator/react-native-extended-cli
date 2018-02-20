#!/bin/bash
set +e

hasJestConfig=$(jq -r 'has("jest")' package.json)


if [[ ${hasJestConfig} == true ]]; then

    JEST_OPTS="$*"
    [ -z "$TEAMCITY_VERSION" ] || {
        JEST_OPTS="$JEST_OPTS -i --coverage"
    }
    jest $JEST_OPTS

else #default is jasmine
    export BABEL_ENV=specs
    node ./test/spec/support/jasmine-runner.js
fi

