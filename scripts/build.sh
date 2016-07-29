#!/bin/bash -e

echo "##teamcity[blockOpened name='rnx build']"

echo "##teamcity[blockOpened name='rnx lint']"
$rnxRoot/scripts/lint.sh
if [ $? -ne 0 ]; then
    echo "Lint failed: build terminating"
    echo "##teamcity[buildStatus status='Lint Failure' text='Lint Failure']"
    exit 3
fi
echo "##teamcity[blockClosed name='rnx lint']"

echo "##teamcity[blockOpened name='rnx test unit']"
$rnxRoot/scripts/test.sh unit
if [ $? -ne 0 ]; then
    echo "Tests failed: build terminating" 
    echo "##teamcity[buildStatus status='Unit Test Failure' text='Unit Test Failure']"   
    exit 4
fi
echo "##teamcity[blockClosed name='rnx test unit']"

if [[ $* != *--skip-ios* ]]; then
    echo "##teamcity[blockOpened name='iOS Build']"
    $rnxRoot/util/build.ios.sh $1
    if [ $? -ne 0 ]; then
        echo "iOS build failed"
        echo "##teamcity[buildStatus status='iOS Build Failed' text='iOS Build Failed']"
        exit 5
    fi
    echo "##teamcity[blockClosed name='iOS Build']"
fi

if [[ $* != *--skip-android* ]]; then
    echo "##teamcity[blockOpened name='Android Build']"
    $rnxRoot/util/build.android.sh $1
    if [ $? -ne 0 ]; then
        echo "Android build failed"
        echo "##teamcity[buildStatus status='Android Build Failed' text='Android Build Failed']"
        exit 6
    fi
    echo "##teamcity[blockClosed name='Android Build']"
fi

echo "##teamcity[blockClosed name='rnx build']"