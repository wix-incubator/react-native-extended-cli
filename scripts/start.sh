#!/bin/bash
watchman watch-del-all && (adb reverse tcp:8081 tcp:8081 || true) && node node_modules/react-native/local-cli/cli.js start