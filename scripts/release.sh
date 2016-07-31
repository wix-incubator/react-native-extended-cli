#!/bin/bash
wnpm-release --no-shrinkwrap
version=$(jq -r '.version' package.json)
$rnxRoot/util/logger.sh buildStatus "Version: ${version}; {build.status.text}"