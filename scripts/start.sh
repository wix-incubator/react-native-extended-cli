#!/bin/bash
pid=`lsof -n -i:8081 | grep LISTEN | awk '{ print $2 }' | uniq`
if [ "$pid" != "" ]; then
  kill -9 $pid
fi
watchman watch-del-all >/dev/null
adb reverse tcp:8081 tcp:8081 >/dev/null 2>&1
adb reverse tcp:3000 tcp:3000 >/dev/null 2>&1
node node_modules/react-native/local-cli/cli.js start