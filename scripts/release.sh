#!/bin/bash
mltci release

mkdir ./artifacts
npm shrinkwrap
mv ./npm-shrinkwrap.json ./artifacts

version=$(jq -r '.version' package.json)
$rnxRoot/util/logger.sh buildStatus "Version: ${version}; {build.status.text}"
