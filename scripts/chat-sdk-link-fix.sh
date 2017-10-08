#!/usr/bin/env bash

if [ "${IS_BUILD_AGENT}" == true ] || [ "${1}" == "release" ]; then
  echo "."
else
  firebaseFile="./node_modules/chat-sdk/node_modules/firebase/firebase-react-native.js"
  echo "Patching ${firebaseFile}"
  sed -i -e "s/require('react-native')/require('..\\/..\\/..\\/chat-mobile\\/node_modules\\/react-native')/g" ${firebaseFile}
fi
