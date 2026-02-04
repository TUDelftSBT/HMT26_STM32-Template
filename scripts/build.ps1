$ErrorActionPreference = "Stop"
$IMAGE = "stm32-dev"
$WORKDIR = "/work"


docker run --rm -t `
  -v "${PWD}:/work" -w /work `
  $IMAGE bash -lc "set -e; git config --global --add safe.directory /work || true; cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug; cmake --build build -j"