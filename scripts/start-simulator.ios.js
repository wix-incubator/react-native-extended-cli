'use strict' //eslint-disable-line
const cp = require('child_process');
const _ = require('lodash');

let iphoneModel = process.env.npm_package_config_iphoneModel;
if (!iphoneModel) {
  iphoneModel = process.argv[2];
}
if (!iphoneModel) {
  throw new Error(`can't find iphoneModel in npm package config OR supplied as an argument`);
}

const all = JSON.parse(cp.execSync(`xcrun simctl list -j devices`)).devices;
const iOSDevices = _.flatten(_.filter(all, (i, key) => key.startsWith('iOS')));
const device = _.find(iOSDevices, (d) => d.name === iphoneModel);
if (!device) {
  throw new Error(`Can't find device with name ${iphoneModel}`);
}

console.log(`Starting simulator ${device.name}`);
try {
  cp.execSync(`xcrun instruments -w ${device.udid} 2> /dev/null || true`);
} catch (e) {
  // ignore
}

//TODO verify simulator started