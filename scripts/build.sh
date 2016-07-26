#!/bin/bash -e

${BASH_SOURCE[0]%/*}/build.ios.sh $1
${BASH_SOURCE[0]%/*}/build.android.sh $1