#!/bin/bash
set +e

echo Linting...
echo
eslint src test demo --cache
