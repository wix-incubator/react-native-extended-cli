#!/bin/bash -e

$rnxRoot/scripts/test.sh

if [ $? -ne 0 ]; then
    echo "Tests failed: build terminating"    
    exit
fi

$rnxRoot/scripts/build.ios.sh $1
$rnxRoot/scripts/build.android.sh $1