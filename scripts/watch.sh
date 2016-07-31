#!/bin/bash
watch '$rnxRoot/scripts/lint.sh; echo ; $rnxRoot/scripts/test.sh unit; if [ $? -eq 0 ]; then notify -m \"OK\" -t \"Watch\"; else notify -m \"ERROR\" -t \"Watch\"; fi' $*
