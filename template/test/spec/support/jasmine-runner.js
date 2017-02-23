/* global process */

const Jasmine = require('jasmine');
const jrunner = new Jasmine();
const {SpecReporter} = require('jasmine-spec-reporter');

const specReporter = new SpecReporter({
  displayStacktrace: 'summary',
  displayFailuresSummary: true,
  displayPendingSummary: true,
  displaySuccessfulSpec: false,
  displayFailedSpec: false,
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
jrunner.loadConfigFile('./test/spec/support/jasmine.json');
jrunner.addReporter(specReporter);

if (process.env.IS_BUILD_AGENT) {
  const TeamCityReporter = require('jasmine-reporters').TeamCityReporter;
  jrunner.addReporter(new TeamCityReporter());
}

jrunner.execute();
