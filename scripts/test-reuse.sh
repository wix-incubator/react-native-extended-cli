#!/bin/bash
# Run tests while reusing existing Appium session to save simulator launch time
BABEL_ENV=specs node ./test/spec/support/jasmine-runner.js

ps aux | grep -v "grep" | grep "appium" > nul
if [ $? -gt 0 ]; then
  echo "Appium not found. Start it in a separate terminal using: node_modules/appium/bin/appium.js --log-level info"
else
  BABEL_ENV=specs reuseAppiumServer=true node ./test/e2e/support/jasmine-runner.js
fi




