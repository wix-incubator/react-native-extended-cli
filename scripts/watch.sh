#!/bin/bash

if [[ $* == *--help* ]]; then
    echo "
    rnx watch --> help 
    ##########################
    # Runs unit tests and lint every time a file changes
    # Options: 
    #  --skip-lint    --> a bunch faster  
    #  --force        --> run the tests even if lint fails
    #########################
"
    exit 0
fi

watch "$rnxRoot/scripts/test.sh --unit $*; if [ $? -eq 0 ]; then notify -m \"OK\" -t \"Watch\"; else notify -m \"ERROR\" -t \"Watch\"; fi" $*
