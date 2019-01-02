#!/bin/bash
set -e

if [[ $* == *--help* ]]; then
    echo "
    rnx test --> help
    ##########################
    # Lint + Tests - Run before you push!!
    # Options:
    #  --force        --> don't stop for failures
    #  --unit         --> skip the e2e tests
    #  --e2e          --> skip the unit tests
    #  --skip-lint    --> Skip lint step
    #  --skip-ts      --> Skip typescript compilation
    #  --skip-jest    --> Guess what it does!!
    #########################
"
    exit 0
fi

if [[ $* != *--skip-lint* ]]; then
  $rnxRoot/util/logger.sh blockOpened "Lint"
  $rnxRoot/scripts/lint.sh
  if [[ $? -ne 0 && $* != *--force* ]]; then
      echo "Lint failed"
      $rnxRoot/util/logger.sh buildStatus "Lint Failed"
      exit 1
  fi
  $rnxRoot/util/logger.sh blockClosed "Lint"
fi

if [[ $* != *--skip-ts* ]]; then
  if [ -f ./tsconfig.json ]; then
    $rnxRoot/util/logger.sh blockOpened "Typescript"
    echo Compiling Typescript...
    tsc

    if [[ $? -ne 0 && $* != *--force* ]]; then
       $rnxRoot/util/logger.sh buildStatus "Typescript Compilation Failed"
       exit 1
    fi
    $rnxRoot/util/logger.sh blockOpened "Typescript"
  fi
fi

if [[ $* != *--e2e* ]]; then
  $rnxRoot/util/logger.sh blockOpened "Unit Tests"
  $rnxRoot/util/test-unit.sh $@
  if [ $? -ne 0 ]; then
    echo "Unit Tests failed"
    $rnxRoot/util/logger.sh buildStatus "Unit Tests Failed"
    exit 1
  fi
  $rnxRoot/util/logger.sh blockClosed "Unit Tests"
fi

if [[ $* != *--unit* ]]; then
  $rnxRoot/util/logger.sh blockOpened "E2E Tests"
  $rnxRoot/util/test-e2e.sh $@
  if [ $? -ne 0 ]; then
    echo "E2E Tests failed"
    $rnxRoot/util/logger.sh buildStatus "E2E Tests Failed"
    exit 1
  fi
  $rnxRoot/util/logger.sh blockClosed "E2E Tests"
fi
