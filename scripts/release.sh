#!/bin/bash
wnpm-release --no-shrinkwrap
version=$(jq -r '.version' package.json)
echo "##teamcity[buildStatus text='Version: ${version}; {build.status.text}']"