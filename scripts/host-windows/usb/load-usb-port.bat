@echo off
setlocal EnableDelayedExpansion

pushd "%~dp0"

set config_file="usb-port.cfg"

IF NOT EXIST %config_file% (
    echo Please create %config_file% in the scripts folder and set the USB port value.
    echo Exiting the program.
    exit 1
)

for /f "usebackq tokens=1,* delims==" %%A in ("usb-port.cfg") do (
    echo %%A | findstr /b "#" >nul
    if errorlevel 1 (
        set "%%A=%%B"
    )
)

endlocal & (
    set "USBPORT=%USBPORT%"
)
