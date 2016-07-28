#!/bin/bash
set -e

echo "##teamcity[blockOpened name='Unit Tests']"
if [ "$1" != "e2e" ]; then
  $rnxRoot/util/test-unit.sh
  if [ $? -ne 0 ]; then
    echo "Unit Tests failed"    
    echo "##teamcity[buildStatus status='Unit Tests Failed' text='Unit Tests Failed']"
    exit 1
  fi
fi
echo "##teamcity[blockClosed name='Unit Tests']"


echo "##teamcity[blockOpened name='E2E Tests']"
if [ "$1" != "unit" ]; then
  $rnxRoot/util/test-e2e.sh $1
  if [ $? -ne 0 ]; then
    echo "E2E Tests failed"    
    echo "##teamcity[buildStatus status='E2E Tests Failed' text='E2E Tests Failed']"
    exit 1
  fi
fi
echo "##teamcity[blockClosed name='E2E Tests']"

