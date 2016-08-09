#!/bin/bash
set -e

if [ "$1" != "e2e" ]; then
  $rnxRoot/util/logger.sh blockOpened "Unit Tests"
  $rnxRoot/util/test-unit.sh $@
  if [ $? -ne 0 ]; then
    echo "Unit Tests failed"    
    $rnxRoot/util/logger.sh buildStatus "Unit Tests Failed"
    exit 1
  fi
  $rnxRoot/util/logger.sh blockClosed "Unit Tests"
fi

if [ "$1" != "unit" ]; then
  $rnxRoot/util/logger.sh blockOpened "E2E Tests"
  $rnxRoot/util/test-e2e.sh $@
  if [ $? -ne 0 ]; then
    echo "E2E Tests failed"
    $rnxRoot/util/logger.sh buildStatus "E2E Tests Failed"    
    exit 1
  fi
  $rnxRoot/util/logger.sh blockClosed "E2E Tests"
fi
