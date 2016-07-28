# react-native-extended-cli
Extended CLI with convenient scripts and utilities for developing React Native apps and modules.
This is an opinionated tool, catered toward a very specific set of conventions that makes life easier for us. 

##Getting Started

```shell
npm install -g react-native-extended-cli
```

## Generator

`rnx` comes with a simple generator that creates new projects in the format that `rnx` commands expect them to be. 
You can specify a specific version of React Native if you don't want to use the latest.  

```
rnx init MyProject 0.29.1
```

##Common Commands

For a complete list of commands, run `rnx` with no arguments. Anything you pass to `rnx` that isn't in that 
list will be passed to the default `react-native-cli`. 

```shell

#run the app (currently only iOS) but don't rebuild, start the packager, or anything else. this is quick
rnx app

#build both android and ios
rnx build

#build just one of the platforms
rnx build <platform>

#lint
rnx lint

#test, optionally just unit or e2e
rnx test [unit|e2e]

#watch - lint and unit tests on all changes
rnx watch

#open the ios project in xcode
rnx xcode


```