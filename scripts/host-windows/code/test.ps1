$ErrorActionPreference = "Stop"
$IMAGE = "stm32-dev"
$WORKDIR = "/work"

docker run --rm -t `
  -v "${PWD}:$WORKDIR" -w $WORKDIR `
  $IMAGE bash -lc "set -e; git config --global --add safe.directory $WORKDIR || true; cmake -S tests -B build-host -DCMAKE_BUILD_TYPE=Debug; cmake --build build-host -j; ctest --test-dir build-host --output-on-failure"
