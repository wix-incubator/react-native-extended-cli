#!/bin/bash
mltci release

if [ -d ./.teamcity ]; then
    echo "Adding npm shrinkwrap to teamcity artifacts"
    npm shrinkwrap
    mv ./npm-shrinkwrap.json ./.teamcity
fi

version=$(jq -r '.version' package.json)
$rnxRoot/util/logger.sh buildStatus "Version: ${version}; {build.status.text}"