const updateNotifier = require('update-notifier');
const pkg = require('../package.json');
const updateCheckInterval = 1000; //once we stop iterating super fast this could be lengthened by a bunch. like once a day, maybe once a week
const notifier = updateNotifier({pkg, updateCheckInterval});
notifier.notify();

