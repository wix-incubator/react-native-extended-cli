#!/bin/bash -e

if [ ! -f ./test/mocks/configuration-facade-mock.private.js ]; then
  echo "export const ConfigurationFacadeMockPrivate = {};" > ./test/mocks/configuration-facade-mock.private.js
fi

$rnxRoot/util/logger.sh blockOpened "rnx build"

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