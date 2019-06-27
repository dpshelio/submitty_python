#!/bin/bash

. helpers_functions.sh

setup_all || exit 1

base=$(pwd)
echo "Checking 3 extra files"
pushd assignment/submission
possibleFiles=( $(find . -maxdepth 1 -type f \( -iname '*.md' -o -iname '*.txt' -o -iname '*.rst' -o -iname '*.cff' -o -iname '*.json' -o ! -name "*.*" \) ) )

readme=0
license=0
citation=0

shopt -s nocasematch
for filepos in ${possibleFiles[@]}; do
    if [[ $filepos = ./readme* ]]; then readme=1; fi
    if [[ $filepos = ./licen* ]]; then license=1; fi
    if [[ $filepos = ./citation* ]]; then citation=1; fi
done

if [[ $((readme + license + citation)) != 3 ]]; then
    echo "Some file may be missing!!"
    exit 1
fi

find ./ -maxdepth 1 -type f \( -iname '*.md' -o -iname '*.txt' -o -iname '*.rst' -o -iname '*.cff' -o -iname '*.json' -o ! -name "*.*" \) -printf "\n\n\n# -----> %p <-----\n" -exec cat {} \; > ${base}/ThreeFILES

touch ${base}/GOODFILES

echo " MARKS from this are (1 automatically + 2 manually)"
