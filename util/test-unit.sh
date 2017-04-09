#!/bin/bash
set +e

export BABEL_ENV=specs
node ./test/spec/support/jasmine-runner.js
