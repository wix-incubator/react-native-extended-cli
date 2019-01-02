#!/bin/bash
set +e

echo Linting...
echo
eslint src test demo --cache

if [ -f ./tsconfig.json ]; then
    tslint -c tslint.json './**/*.{ts,tsx}' -e 'node_modules/**/*' -p tsconfig.json -t stylish
fi



