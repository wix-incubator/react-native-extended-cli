#!/bin/bash -e

${BASH_SOURCE[0]%/*}/test.sh

if [ $? -ne 0 ]; then
    echo "Tests failed: build terminating"    
    exit
fi

${BASH_SOURCE[0]%/*}/build.ios.sh $1
${BASH_SOURCE[0]%/*}/build.android.sh $1