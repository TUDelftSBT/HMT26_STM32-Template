$ErrorActionPreference = "Stop"

$IMAGE = "stm32-dev"
$WORKDIR = "/work"

$bashCmd = "set -euo pipefail; " +
           "rm -rf build-host; " +
           "cmake -S tests -B build-host -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON; " +
           "echo 'Analyzing files:'; " +
           "find Project Modules -type f \( -name '*.c' -o -name '*.cpp' \) | wc -l; " +
           "find Project Modules -type f \( -name '*.c' -o -name '*.cpp' \) -print0 | " +
           "xargs -0 -r clang-tidy -p build-host " +
           "2>&1 | tee build-host/clang-tidy.txt"

docker run --rm -t `
  -v "${PWD}:$WORKDIR" -w $WORKDIR `
  $IMAGE bash -lc $bashCmd
