#!/bin/bash

# To run in the provided_code folder
current_dir=${PWD}

if [[ "${current_dir##*/}" != 'provided_code' ]]; then
    exit 1
fi


mkdir python_envs
pushd python_envs

function create_env() {
    python3 -m venv $1
    source student_env/bin/activate
    pip install -q -r ${current_dir}/$2
    deactivate
}

# Create simple environment with nothing pre-installed
create_env student_env requirements_basic.txt
# Create environment with development tools
create_env dev_env requirements_dev.txt

popd

# Create a tar file to pass between the autograding phases
# https://submitty.org/instructor/assignment_configuration#phases-of-autograding
tar zcvf python_envs.tar.gz python_envs
rm -rf python_envs
