#!/bin/bash

# pushd/popd that produces no output
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

debug=0

if [[ ${debug} == 1 ]]; then ls -lhtra; fi

base=$(pwd)


# Find tar.gz files within the directories with a student number (8 digits)
studenttgz=($(find . -maxdepth 1 -type f -regextype posix-awk -regex '\.\/[0-9]{8}\.tar\.gz'))
if [[ ${#studenttgz[@]} != 1 ]]; then
    echo "No correct file uploaded - it needs to be <studentNumber>.tar.gz"
    exit 1
fi


# Un-tar and check whether a student number directory exists in the tar file
tar zxf $studenttgz
studentfolder=($(find . -maxdepth 1 -type d -regextype posix-awk -regex '\.\/[0-9]{8}'))
if [[ ${#studentfolder[@]} != 1 ]]; then
    echo "None or more than one student directory!"
    echo "The uploaded tar.gz file must only contain a folder which name is your student number."
    exit 1
fi


# CLEANING
## Find number of files (except these under the `.git` directory)
orig_dirfilesN=( $(find $studentfolder -type d | wc -l) $(find ./ -type f | wc -l))
find $studentfolder | grep -v '.git' > orig_dirfiles

## Remove not committed files
pushd $studentfolder
git clean -fxd
git reset --hard HEAD
popd

## Remove any mac files submitted
find $studentfolder -type d -iname '__MACOSX*'  | xargs rm -rf #  Because with exec says files are not there
## Remove cache, pyc and eggs
dirs=( "__pycache__" "dist" "build" "*.egg*" )
for dir in $dirs[@]; do
    find $studentfolder -type d -iname "$dir" | xargs rm -rf #  Because with exec says files are not there
done
## Remove files like pyc and any other hidden files
find $studentfolder -type f -iname '*.pyc'  | xargs rm -f
find $studentfolder -iname '.?*' -not -iname '.git*' | xargs rm -rf # Removing hidden files or directories

## Count directories and files after clean up
dirfilesN=( $(find $studentfolder -type d | wc -l) $(find ./ -type f | wc -l))
find $studentfolder | grep -v '.git' > dirfiles
if [[ ${orig_dirfilesN[@]} != ${dirfilesN[@]} ]]; then
    echo "$((orig_dirfilesN[0] - dirfilesN[0])) directories and $((orig_dirfilesN[1] - dirfilesN[1])) files removed"
    diff orig_dirfiles dirfiles
fi


# Folder to include python env and submission
mkdir assignment

# Create a folder `submission` to fix it and move it around
mv $studentfolder assignment/submission

pushd assignment

# Check that there are files to be graded: py, md, txt and/or rst.
goodfiles=$(find submission/ -type f -iname '*.py' -o -iname '*.md' -o -iname '*.txt' -o -iname '*.rst' | wc -l)
if [[ ${goodfiles} < 1 ]]; then
    echo "No files to analyse"
    exit 1
fi

if [[ ${debug} == 1 ]]; then
    validfiles=$(find submission/ | sed 's|submission/||')
    echo "Files to be analysed"
    echo $validfiles
fi

# Copy python's venv - student_env.zip is created as running create_env.sh
tar zxf ${base}/python_envs.tar.gz
popd

# We create a submission.zip.out file as other things are not transferred by Submitty!
tar zcf submission.tar.gz.out assignment

if [[ ${debug} == 1 ]]; then ls -lhtra; fi
