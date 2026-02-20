#!/bin/bash

# To be ran from within the devcontainer
mkdir -p ./build-test-on-host

cmake -S tests/on-host -B ./build-test-on-host -DCMAKE_BUILD_TYPE=Debug
cmake --build ./build-test-on-host -j
ctest --test-dir ./build-test-on-host --output-on-failure
