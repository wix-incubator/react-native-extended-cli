#!/bin/bash
set +e

if [ -f ./tsconfig.json ]; then
    $rnxRoot/util/logger.sh blockOpened "Typescript"
    echo Compiling Typescript...
    tsc

    if [[ $? -ne 0 && $* != *--force* ]]; then
       $rnxRoot/util/logger.sh buildStatus "Typescript Compilation Failed"
       exit 1
    fi
    $rnxRoot/util/logger.sh blockClosed "Typescript"
fi
