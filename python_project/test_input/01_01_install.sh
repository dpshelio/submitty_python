#!/bin/bash

. helpers_functions.sh

setup_all || exit 1

# Install the library
install greet || exit 1
