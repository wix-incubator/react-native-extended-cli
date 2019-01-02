#!/bin/bash

if [[ $* == *--help* ]]; then
    echo "
    rnx watch --> help
    ##########################
    # Runs unit tests and lint every time a file changes
    # Options:
    #  --skip-lint    --> a bunch faster
    #  --skip-ts      --> skip typescript, if relevant
    #  --force        --> run the tests even if lint/typescript fails
    #  --paths        --> override the default directories  to watch
    #
    # By default, this command watches for file changes in
    # the src/ and test/ directories. If you pass a --paths argument,
    # these will be overrided with the supplied paths. For example,
    # to watch the src and foo directories but NOT the test directory:
    #
    # > rnx watch --paths=\"src foo\"
    #
    #########################
"
    exit 0
fi

paths="src test"
args=$*
while [ $# -gt 0 ]; do
  case "$1" in
    --paths=*)
      paths="${1#*=}"
      ;;
  esac
  shift
done

watch "$rnxRoot/scripts/test.sh --unit $args; if [ $? -eq 0 ]; then notify -m \"OK\" -t \"Watch\"; else notify -m \"ERROR\" -t \"Watch\"; fi" $paths
