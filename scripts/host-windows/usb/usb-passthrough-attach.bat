@REM TODO new terminal open

setlocal

@REM Change cwd to this folder
pushd "%~dp0"

call .\\load-usb-port.bat

echo "Attaching to: " %USBPORT%

start /B usbipd attach --wsl --busid %USBPORT% --auto-attach
endlocal
