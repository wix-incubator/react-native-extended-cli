#!/bin/bash
mltci release

if [ -d ./.BuildServer/config/.teamcity ]; then
    echo "Adding npm shrinkwrap to teamcity artifacts"
    npm shrinkwrap
    mv ./npm-shrinkwrap.json /.BuildServer/config/.teamcity
else
    echo ".teamcity not found"
fi

version=$(jq -r '.version' package.json)
$rnxRoot/util/logger.sh buildStatus "Version: ${version}; {build.status.text}"