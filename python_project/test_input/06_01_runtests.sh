#!/bin/bash

. helpers_functions.sh

setup_all || exit 1

source assignment/python_envs/dev_env/bin/activate

base=$(pwd)
echo "Running tests"

pushd assignment/submission


# concatenate all tests files into a single one to copy into the hand marking
find ./ -type f -iname 'test_*.py' -printf "\n\n\n# -----> %p <-----\n" -exec cat {} \; > ${base}/ALLTESTS.py
fixtfiles=($(find ./ -type f | grep -i "fixt"))

touch ${base}/ALLFixtures.yaml
for file_i in ${fixtfiles[@]}; do
    printf "\n\n\n# -----> ${file_i} <-----\n" >> ${base}/ALLFixtures.yaml
    cat ${file_i} >> ${base}/ALLFixtures.yaml
done


pytest -v --cov=greetings --cov-report term > ${base}/TESTOUTPUT
output_test=$?

if [[ ${output_test} != 0 ]]; then
    echo "tests have failed!"
    cat ${base}/TESTOUTPUT
    rm ${base}/TESTOUTPUT
    exit 1
fi
