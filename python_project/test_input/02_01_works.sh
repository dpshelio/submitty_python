#!/bin/bash

base=$(pwd)
. helpers_functions.sh

setup_all || exit 1
source assignment/python_envs/dev_env/bin/activate

pushd assignment/submission

python -c 'from greetings.greet import greet' > ${base}/WORKS 2>&1

popd
if [ -s WORKS ]; then
    echo "NOTE: all marks would be invalid if `greet` cannot be imported."

fi
