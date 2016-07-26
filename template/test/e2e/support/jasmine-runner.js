/* global process */

const Jasmine = require('jasmine');
const jrunner = new Jasmine();
const SpecReporter = require('jasmine-spec-reporter');

const specReporter = new SpecReporter({
  displayStacktrace: 'all',
  displayFailuresSummary: true,
  displayPendingSummary: true,
  displaySuccessfulSpec: true,
  displayFailedSpec: true,
  displayPendingSpec: true,
  displaySpecDuration: true,
  displaySuiteNumber: false,
  colors: {
    success: 'green',
    failure: 'red',
    pending: 'yellow'
  },
  prefixes: {
    success: '✓ ',
    failure: '✗ ',
    pending: '* '
  },
  customProcessors: []
});

jrunner.configureDefaultReporter({print: () => {}});
jrunner.loadConfigFile('./test/e2e/support/jasmine.json');
jrunner.addReporter(specReporter);

if (process.env.IS_BUILD_AGENT) {
  const TeamCityReporter = require('jasmine-reporters').TeamCityReporter;
  jrunner.addReporter(new TeamCityReporter());
}

jrunner.execute(process.env.specFilterString ? [process.env.specFilterString] : undefined);
