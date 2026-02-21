#!/bin/bash

# To be ran from within the devcontainer
mkdir -p ./build-test-on-host

cmake -S tests/on-host -B ./build-test-on-host -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build ./build-test-on-host -j --parallel
ctest --test-dir ./build-test-on-host --output-on-failure
