#!/bin/bash
set -e
appName=$npm_package_config_appName
scheme=$npm_package_config_appName

node ./node_modules/react-native/local-cli/cli.js bundle --entry-file index.ios.js --platform ios --dev false --bundle-output ./ios/Build/Products/${scheme}-iphonesimulator/${appName}.app/main.jsbundle --assets-dest ./ios/Build/Products/${scheme}-iphonesimulator/${appName}.app
