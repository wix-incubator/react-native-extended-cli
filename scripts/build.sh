#!/bin/bash -e

npm run lint

if [ $? -ne 0 ]; then
    echo "Tests failed: build terminating"    
    exit
fi

$rnxRoot/scripts/test.sh

if [ $? -ne 0 ]; then
    echo "Tests failed: build terminating"    
    exit
fi

$rnxRoot/util/build.ios.sh $1
$rnxRoot/util/build.android.sh $1