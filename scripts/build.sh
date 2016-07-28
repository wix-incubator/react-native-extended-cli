#!/bin/bash -e

echo "##teamcity[blockOpened name='rnx build']"

echo "##teamcity[buildStatus status='Lint Failure' text='Lint Failure.']"
exit 3

echo "##teamcity[blockOpened name='rnx lint']"
$rnxRoot/scripts/lint.sh
if [ $? -ne 0 ]; then
    echo "Lint failed: build terminating"
    echo "##teamcity[buildStatus status='Lint Failure' text='Lint Failure.']"
    exit 3
fi
echo "##teamcity[blockClosed name='rnx lint']"

echo "##teamcity[blockOpened name='rnx test unit']"
$rnxRoot/scripts/test.sh unit
if [ $? -ne 0 ]; then
    echo "Tests failed: build terminating"    
    exit 4
fi
echo "##teamcity[blockClosed name='rnx test unit']"

echo "##teamcity[blockOpened name='iOS Build']"
$rnxRoot/util/build.ios.sh $1
if [ $? -ne 0 ]; then
    echo "iOS build failed"    
    exit 5
fi
echo "##teamcity[blockClosed name='iOS Build']"

echo "##teamcity[blockOpened name='Android Build']"
$rnxRoot/util/build.android.sh $1
if [ $? -ne 0 ]; then
    echo "Android build failed"    
    exit 6
fi
echo "##teamcity[blockClosed name='Android Build']"

echo "##teamcity[blockClosed name='rnx build']"