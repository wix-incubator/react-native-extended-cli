#!/bin/bash
set -e

if [ "$1" != "e2e" ]; then
  $rnxRoot/util/test-unit.sh
fi

if [ "$1" != "unit" ]; then
  $rnxRoot/util/test-e2e.sh  
fi