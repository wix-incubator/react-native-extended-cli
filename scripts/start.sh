#!/bin/bash
pid=`lsof -n -i:8081 | grep LISTEN | awk '{ print $2 }' | uniq`
if [ "$pid" != "" ]; then
  kill -9 $pid
fi
watchman watch-del-all
adb reverse tcp:8081 tcp:8081 || true
adb reverse tcp:3000 tcp:3000 || true
node node_modules/react-native/local-cli/cli.js start