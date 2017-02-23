const hasbin = require('hasbin');

const logMessage = (binary, packageManager) => {
  console.log(`
  
  Dependency check failed for binary ${binary}.
  You need to have it installed for rnx to work. 
  If it's already installed, make sure it's on the path.
  If not, try:
  
  ${packageManager === 'npm' ? `npm install -g ${binary}` : ''}
  ${packageManager === 'brew' ? `brew install ${binary}` : ''}
  
  `);
};

hasbin('jq', result => {
  if (!result) {
    logMessage('jq', 'brew');
    process.exit(1);
  }
});

// hasbin('yarn', result => {
//   if (!result) {
//     logMessage('yarn', 'npm');
//     process.exit(1);
//   }
// });