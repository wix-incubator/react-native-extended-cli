const detox = require('detox');
const config = require('../../package.json').detox;
const PROJECT_NAME = require('../../package.json').config.appName;
const RELEASE_MODE = process.argv.slice(2).indexOf('release') > -1;

if (process.env.IS_BUILD_AGENT || RELEASE_MODE) { //eslint-disable-line
  config['ios-simulator'].app = `ios/DerivedData/${PROJECT_NAME}/Build/Products/Release-iphonesimulator/${PROJECT_NAME}.app`;
}

before(function (done) {
  this.timeout(40000);
  detox.config(config);
  detox.start(done);
});

afterEach(done => {
  detox.waitForTestResult(done);
});

after(done => {
  detox.cleanup(done);
});
