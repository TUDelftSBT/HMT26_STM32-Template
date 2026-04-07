#!/bin/bash
set -e

build_dir="./build/test-on-host"

if [ ! -d $build_dir ] || [ -z "$(ls -A $build_dir)" ]; then
    mkdir -p $build_dir
    cmake -S tests/on-host -B $build_dir -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
fi

cmake --build $build_dir -j --parallel
ctest --test-dir $build_dir --output-on-failure
