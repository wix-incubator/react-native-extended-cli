#!/bin/bash -e

if [[ "${USE_ENGINE}" == true ]]; then 
  echo Skipping Android
else 
  node ./node_modules/react-native/local-cli/cli.js run-android
fi