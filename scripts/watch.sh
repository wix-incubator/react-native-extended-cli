#!/bin/bash
watch 'npm run lint; flow; npm run test:unit --silent; if [ $? -eq 0 ]; then notify -m \"OK\" -t \"Watch\"; else notify -m \"ERROR\" -t \"Watch\"; fi' $*
