#!/bin/bash

. helpers_functions.sh
base=$(pwd)

setup_all || exit 1

echo "Checking .git inside student folder"
gitDirectory GITCHECKED || exit 1

# Create empty file as success
touch GITCHECKED

pushd assignment/submission

git log --stat --full-history | sed '/^Author/d' > ${base}/GITHISTORY

echo " MARKS from this are (1 automatically + 3 manually) / 2 "
