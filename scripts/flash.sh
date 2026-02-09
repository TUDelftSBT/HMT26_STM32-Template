#!/usr/bin/env bash
set -euo pipefail

# Parameters
DO_BUILD=1
DO_MASS_ERASE=1
DO_READBACK=0
ADAPTER_KHZ=1000
ELF_PATH="build/HMT26_FIRMWARE.elf"


# Paths
OPENOCD_SCRIPTS_DIR="/usr/local/share/openocd/scripts"
IF_CFG="${OPENOCD_SCRIPTS_DIR}/interface/stlink.cfg"
TGT_CFG="${OPENOCD_SCRIPTS_DIR}/target/stm32f4x.cfg"


# Helpers
log() { echo -e "\n==> $*"; }
die() { echo "ERROR: $*" >&2; exit 1; }
need_cmd() { command -v "$1" >/dev/null 2>&1 || die "'$1' not found in PATH."; }

usage() {
  cat <<'EOF'
Usage: ./scripts/flash.sh
Edit settings at the top of this script to change speed/erase/readback/run.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi


# Checks
need_cmd openocd
need_cmd lsusb
need_cmd cmake

[[ -f "${IF_CFG}"  ]] || die "OpenOCD interface config not found: ${IF_CFG} (container?)"
[[ -f "${TGT_CFG}" ]] || die "OpenOCD target config not found: ${TGT_CFG} (container?)"
[[ "${ADAPTER_KHZ}" =~ ^[0-9]+$ ]] || die "ADAPTER_KHZ must be numeric (kHz)"


# Build
if [[ "${DO_BUILD}" -eq 1 ]]; then
  log "Building firmware (Debug) into ./build ..."
  rm -rf build
  cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
  cmake --build build -j
fi

[[ -f "${ELF_PATH}" ]] || die "ELF not found: ${ELF_PATH}"


# Verify ST-Link
log "Checking ST-Link visibility via lsusb ..."
if ! lsusb | grep -iE "stlink|st-link|stmicroelectronics" >/dev/null; then
  die "ST-Link not visible via lsusb. (WSL? usbipd attach + container --privileged)"
fi
echo "OK: ST-Link detected."

if [[ ! -d /dev/bus/usb ]]; then
  die "/dev/bus/usb not present. Start docker with: --privileged -v /dev/bus/usb:/dev/bus/usb"
fi


# Flash
log "Flashing: ${ELF_PATH}"
log "Adapter speed: ${ADAPTER_KHZ} kHz"
log "Mass erase: $([[ "${DO_MASS_ERASE}" -eq 1 ]] && echo enabled || echo disabled)"
log "Readback: $([[ "${DO_READBACK}" -eq 1 ]] && echo enabled || echo disabled)"


OPENOCD_CMDS=(
  -c "transport select swd"
  -c "adapter speed ${ADAPTER_KHZ}"
  -c "reset_config srst_only srst_nogate connect_assert_srst"
  -c "init"
  -c "reset halt"
)

if [[ "${DO_MASS_ERASE}" -eq 1 ]]; then
  OPENOCD_CMDS+=(-c "stm32f2x mass_erase 0")
fi

# Verify
OPENOCD_CMDS+=(
  -c "program ${ELF_PATH} verify"
)

if [[ "${DO_READBACK}" -eq 1 ]]; then
  OPENOCD_CMDS+=(-c "reset halt; mdw 0x08000000 16")
fi

OPENOCD_CMDS+=(-c "shutdown")

openocd -f "${IF_CFG}" -f "${TGT_CFG}" "${OPENOCD_CMDS[@]}"

log "Done."
