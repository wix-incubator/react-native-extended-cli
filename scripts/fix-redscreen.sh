#!/bin/bash -e

find ./node_modules/react-native/React/Modules/RCTRedBox.m -type f -exec sed -i '' 's/clearColor/colorWithRed:0.8 green:0 blue:0 alpha:1/g' {} \\;