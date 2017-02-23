const hasbin = require('hasbin');

const logMessage = binary => {
  console.log(`
    Dependency check failed for binary ${binary}.
    You need to have it installed for rnx to work. 
    Try 'brew install ${binary}'.
    If it's already installed, make sure it's on the path.
  `);
};

hasbin('jq', result => {
  if (!result) {
    logMessage('jq');
    process.exit(1);
  }
});