#!/bin/bash

. helpers_functions.sh

setup_all || exit 1

# Install the library
install || exit 1

# Check that greet is there
which greet > EXISTS

greet_command=$(grep -c "not found" EXISTS)
if [[ $greet_command != 0 ]]; then
    rm EXISTS
    echo "the `greet` command doesn't exist"
    exit 1
fi

# Run it with a file
greet --title Sir Galahad Pure > /dev/null 2>&1
run_good=$?

greet me > /dev/null 2>&1
run_bad=$?

# If output of run_good error or succeed with a wrong input
if [[ ${run_good} != 0 ]] || [[ ${run_bad} == 0 ]]; then
    rm EXISTS
    echo "greet doesn't run/error as expected"
    exit 1
fi

# TODO - Comparing expected output?
