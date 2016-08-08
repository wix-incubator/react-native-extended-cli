#!/bin/bash -e

$rnxRoot/util/logger.sh blockOpened "rnx build"
$rnxRoot/util/logger.sh blockOpened "rnx lint"
$rnxRoot/scripts/lint.sh
if [[ $? -ne 0 && $* != *--force* ]]; then
    echo "Lint failed: build terminating"
    $rnxRoot/util/logger.sh buildStatus "Lint Failed"
    exit 3
fi
$rnxRoot/util/logger.sh blockClosed "rnx lint"

$rnxRoot/util/logger.sh blockOpened "rnx test unit"
$rnxRoot/scripts/test.sh unit
if [[ $? -ne 0 && $* != *--force* ]]; then
    echo "Tests failed: build terminating" 
    $rnxRoot/util/logger.sh buildStatus "Unit Tests Failed"
    exit 4
fi
$rnxRoot/util/logger.sh blockClosed "rnx test unit"

if [[ $* != *--skip-ios* ]]; then
    $rnxRoot/util/logger.sh blockOpened "iOS Build"
    $rnxRoot/util/build.ios.sh $1
    if [[ $? -ne 0 && $* != *--force* ]]; then
        echo "iOS build failed"    
        $rnxRoot/util/logger.sh buildStatus "iOS Build Failed"
        exit 5
    fi
    $rnxRoot/util/logger.sh blockClosed "iOS Build"
fi

if [[ $* != *--skip-android* ]]; then
    $rnxRoot/util/logger.sh blockOpened "Android Build"
    $rnxRoot/util/build.android.sh $1
    if [[ $? -ne 0 && $* != *--force* ]]; then
        echo "Android build failed"    
        $rnxRoot/util/logger.sh buildStatus "Android Build Failed"
        exit 6
    fi
    $rnxRoot/util/logger.sh blockClosed "Android Build"  
fi
$rnxRoot/util/logger.sh blockClosed "rnx build"