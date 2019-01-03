#!/bin/bash
set +e

echo Linting JS...
echo
eslint src test demo --cache

if [[ $? -ne 0 && $* != *--force* ]]; then
    exit 1
fi

if [ -f ./tsconfig.json ]; then
    echo Linting Typescript...
    echo

    tslint -c tslint.json './**/*.{ts,tsx}' -e 'node_modules/**/*' -p tsconfig.json -t stylish

    if [[ $? -ne 0 && $* != *--force* ]]; then
        exit 1
    fi
fi



