#!/bin/bash
mltci release
ARTIFACTS_FOLDER="./artifacts"

mkdir $ARTIFACTS_FOLDER
cp ./package-lock.json $ARTIFACTS_FOLDER
mv $ARTIFACTS_FOLDER ../

version=$(jq -r '.version' package.json)
$rnxRoot/util/logger.sh buildStatus "Version: ${version}; {build.status.text}"
