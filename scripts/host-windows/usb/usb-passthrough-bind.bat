setlocal

@REM Change cwd to this folder
pushd "%~dp0"

call .\\load-usb-port.bat

echo "Binding to: " %USBPORT%

usbipd bind --busid %USBPORT%
endlocal
