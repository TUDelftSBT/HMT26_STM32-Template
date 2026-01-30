@echo off
setlocal EnableDelayedExpansion

pushd "%~dp0"

for /f "usebackq tokens=1,* delims==" %%A in ("usb-port.cfg") do (
    echo %%A | findstr /b "#" >nul
    if errorlevel 1 (
        set "%%A=%%B"
    )
)

endlocal & (
    set "USBPORT=%USBPORT%"
)
