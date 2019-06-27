#!/bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

function untar_submission () {
    # untars the file that comes from compilation
    [[ -f submission.tar.gz.out ]] || exit 1
    tar zxf submission.tar.gz.out
}

function subdir () {
    if [[ ! -d assignment/submission ]]; then
        echo "First step not passed - probably there's something wrong with the submission"
        echo "Fail [1]"  > $1
        echo "$(ls -aF)"
        exit 1
    fi
}

function git_directory () {
    if [[ ! -d assignment/submission/.git ]]; then
        echo "Git directory not found in $(pwd)"
        echo "Fail [3]"  > $1
        echo "$(ls -aF)"
        exit 1
    fi
}

function venv_local () {
    # Change the paths from where the environment was created to the execution directory
    badpath=$(cat assignment/python_envs/root_path)
    goodpath="$(pwd)/assignment/python_envs"

    for bins in "student_env" "dev_env"
    do
        find assignment/python_envs/${bins}/bin -type f -exec sed -i "s|$badpath|$goodpath|g" {} \;
    done
}

function setup_all () {
    # get the assignment folder
    untar_submission || exit 1
    # Is the directory there?
    subdir SETUP || exit 1
    # update environments to this directory
    venv_local || exit 1
}

function install () {
    # Run the installation of the submission if it's possible
    # usage:   install nameprogram
    #
    # - nameprogram is used to check is recognised by pip.
    base=$(pwd)
    # Load environment
    source assignment/python_envs/student_env/bin/activate
    pushd assignment/submission
    if [[ ! -f setup.py ]]; then
        echo "setup.py not found "
        exit 1
    fi
    pip_cache=${base}/.cache/pip
    mkdir -p ${pip_cache}
    pip install . --cache-dir ${pip_cache} > INSTALLATION || exit 1
    popd

    pip list --format=columns | grep -i $1 > ${base}/INSTALLED

}
