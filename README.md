# _--New project name--_
*Your description here*

## About this template
This repo includes a setup for developing on STM32 using a custom build toolchain which allows you to use other GIT repositories as modules.

## Project setup
1. Fork this project or create a copy.
2. Open a new STM32CubeMX project and set the following settings in the project manager tab:
  - Project name: (same name as the folder/repo name)
  - Project location: (folder above the folder/repo)
  - Application structure: Advanced
  - Toolchain/IDE: CMake
3. Click generate code in the top right and run from your or my favourite IDE. If you're using vscode, use the included devcontainer. This allows you to build and debug easily using the ESProgrammer. 
4. To create your own code, you can use the Project folder.

## Using GIT hashes in your code as versions
The versions will be included at compile-time in a file called version.c. The version.h already exists before compilation, so you can include that in your file where you need the GIT hash. You can then use the variable with the first 6 tokens of the git hash in your project.
```.c
extern const uint32_t GIT_HASH;
```
This is its definition.

## Using modules
To include modules, add the module name, SSH Git URL and hash/version to the modules.txt file:
```
example ssh@gitlab.com/example.ssh main
```

## Running
### On windows
1. Compile your code using the build button in vscode (should automatically appear when you load the devcontainer).
2. Debug and flash your code over internet using the ESProgrammer (personal project of mine). You can also flash using an OpenOCD adapter like the STLink: if you are using the vscode devcontainer, you can use `usbipd list` to list all USB devices on windows, `usbipd bind --busid <busid of your device>` to bind the USB device (only done once) and run `usbipd attach --wsl --busid <busid of your device> --auto-attach` everytime you want to flash, this will automatically forward the device to your PC. You should be able to debug and flash using OpenOCD.

### On Linux
1. Install OpenOCD from source (via package manager are almost always outdated).
2. Install arm-eabi-none from source.
3. You can now easily flash and build from linux. Make sure to setup the $PATH variables and launch.json correcctly.

## Credits
Template created by Daan Posthumus.

## License
Feel free to use it.