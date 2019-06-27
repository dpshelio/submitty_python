#!/bin/bash

. helpers_functions.sh

setup_all || exit 1

echo "Checking pep8 output from greeter.py"
lab=( $(find assignment/submission -type f -name 'greeter.py') )
if [[ ${#lab[@]} != 1 ]]; then
    echo "File greeter.py not found or more than one greeter.py files in your submission."
    echo " are you submitting some extra folders like dist, build, ...? Please, remove them before submission."
    exit 1
fi

# Load environment
source assignment/python_envs/dev_env/bin/activate
echo " Checking PEP 8 "
pycodestyle ${lab}

pycodestyle --ignore=E121,E123,E126,E226,E24,E704,W503,W504,E501 ${lab} > PEP8
