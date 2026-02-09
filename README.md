# _--New project name--_
*Your description here*

## About this template
This repo includes a setup for developing on STM32 using a custom build toolchain which allows you to use other GIT repositories as modules.

## Project setup
1. Fork this project or use it as a template. (There are [some differences](https://stackoverflow.com/questions/62082123/github-what-is-the-difference-between-template-and-fork-concepts-and-when-to-us))
2. Change the STM32CUBEMX project accordingly via the `HMT26_template.ioc` file or more easily via the STM32CUBEMX editor.
3. Click generate code in STM32CUBEMX
4. Use your favorite IDE. If you're using vscode, use the included devcontainer. See below how to open the devcontainer via a task.
5. To create your own code, you can use the Project folder.

### Extra steps for Windows
1. Run the `usb-passthrough-install.bat` to install `usbipd` on Windows.
2. Use `usb-passthrough-list.bat` to find where your STLink is connected.
3. Create a copy of the `usb-port.cfg.template` and rename it to `usb-port.cfg` and edit the usb port to the one you just found.
4. Run `usb-passthrough-bind.bat`

## ST32CUBEMX project
There is one file in this project related to the ST32CUBEMX project. ST32CUBEMX can be installed via the website, then going to downloads, entering your email and then installing it via the installer that you got in your email.

The ST32CUBEMX project is used to automatically generate code. In there you can set the pinout, which peripherals to enable, and which functionality to use of the STM32. The default project in here enables the entire team to have the same general configuration. Of course, you have to change it per PCB type / codebase.

If you wish to change the name of the project, you can do that quite easily. You can change the name of the `HMT26_template.ioc` file, then you have to edit the two fields of the file:
```
ProjectManager.ProjectFileName=HMT26_template.ioc
ProjectManager.ProjectName=HMT26_template
```

STM32CUBEMX should then notice the changed project name.

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
> [!IMPORTANT]
> You must have followed the setup for windows above!!!

1. Open the devcontainer using the `Rebuild & Reopen Devcontainer` task (so open it via the keybindings below), not the default one from VSCode. This task attaches the USB port everytime you enter the devcontainer.
2. Build and flash using the shortcut below

### On Linux
1. Install OpenOCD from source (via package manager are almost always outdated).
2. Install arm-eabi-none from source.
3. You can now easily flash and build from linux. Make sure to setup the $PATH variables and launch.json correcctly.

## Keybindings
| Action    | Shortcut |
| -------- | ------- |
| Open task  | `ctrl+shift+P` then `Run task` then your task    |
| Build and flash (in container) | `ctrl+shift+b` |

## Custom Keybindings
Erik wanted to add custom keybindings for certain tasks, but this did not work. He tried to follow the [vscode docs](https://code.visualstudio.com/docs/debugtest/tasks#_binding-keyboard-shortcuts-to-tasks) and [this stackoverflow post](https://stackoverflow.com/questions/48945319/a-keybindings-json-per-workspace-in-visual-studio-code), but did not manage to get it to work. So fix it if you'd like!

## Setup
### Easy scripts
We made building, flashing, running unittest easy with a couple of scripts.

Make sure to have Docker Desktop installed and running.

To create the docker image etc you can run

```
.\scripts\image.ps1
```

To run the static analysis same as in the pipeline run

```
.\scripts\analysis.ps1  
```
The report is generated in ```build-host/clang-tidy.txt```

To build the code
```
.\scripts\build.ps1
```

Unit tests can be run with
```angular2html
.\scripts\test.ps1
```

### Static analysis integration
Static analysis can be made nicer with clion integration. Download using this

```
winget install --id LLVM.LLVM -e
```
Add the bin file to the path variables. You got this I believe in you.

check with
```
clang-tidy --version
clangd --version
```


### Flashing
Then we move on too flashing. To flash we need to do a bit more because we have to figure out the usb ports.

You will need

```
winget install usbipd
usbipd version
```

#### Attach the ST-Link to WSL

These are the tools
```
usbipd list
usbipd bind --busid <BUSID>
usbipd attach --wsl --busid <BUSID>
```

If you have trouble you can also use this
### Extra steps for Windows
1. Run the `usb-passthrough-install.bat` to install `usbipd` on Windows.
2. Use `usb-passthrough-list.bat` to find where your STLink is connected.
3. Create a copy of the `usb-port.cfg.template` and rename it to `usb-port.cfg` and edit the usb port to the one you just found.
4. Run `usb-passthrough-bind.bat`

Next we verify that it worked
This opens wsl
```
wsl
```

Running this you should see you ST-link
```
lsusb | grep -i st
```

To build the docker image

```
docker build -t stm32-dev -f .devcontainer/Dockerfile .
```

Then to run a container with the repo mounted

```
docker run --rm -it --privileged \
  -v /dev/bus/usb:/dev/bus/usb \
  -v $PWD:/work -w /work stm32-dev bash
```

[//]: # (docker run --rm -it -v ${PWD}:/work -w /work stm32-dev bash)

from inside the docker (Build + flash)

```
./scripts/flash.sh
```



















### IF the above it not working out maybe this will help

The project uses docker so that we are not dependent of the OS.

But man if you understand what I did here you are going to think I am crazy

Anyway this is the chain that has to work to get code on the pcb:
Windows → usbipd → WSL2 → Docker → OpenOCD → ST-Link → STM32

Make sure to have Docker Desktop installed and running.


To build the docker image

```
docker build -t stm32-dev -f .devcontainer/Dockerfile .
```

Then to run a container with the repo mounted

```
docker run --rm -it -v ${PWD}:/work -w /work stm32-dev bash
```

required on Windows bind mounts, not sure if others will have issues, but git has a safety check

```
git config --global --add safe.directory /work
```

Build (+ some other stuff)
```
rm -rf build
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j
```

if you want to run the tests in test folders do the following

```
rm -rf build-host
cmake -S tests -B build-host -DCMAKE_BUILD_TYPE=Debug
cmake --build build-host -j
ctest --test-dir build-host --output-on-failure
```

If gcc and g++ not working then first off that is very interesting and probably a problem but to check run

```
gcc --version
g++ --version
```

and fix
```
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

docker build -t stm32-dev -f .devcontainer/Dockerfile .
```



## local pipeline
To run the pipeline locally

```
winget install nektos.act
act --version
```

then
```
act -W .github/workflows/ci.yml
```



Verify inside wsl with
```
wsl
```

```
lsusb | grep -i st
```

Build the docker

```
docker build -t stm32-dev -f .devcontainer/Dockerfile .

docker run --rm -it --privileged \
  -v ${PWD}:/work -w /work \
  stm32-dev bash
```

Build firmware
```
rm -rf build
git config --global --add safe.directory /work
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j
```

you can check with
```
ls build/*.elf
```
expected is ```build/HMT26_FIRMWARE.elf```


Verify ST-Link Access Inside Docker
```
ls -l /dev/bus/usb
or
find /dev/bus/usb -type c
or 
lsusb | grep -i st
```

Then we flash with

```
openocd \
  -f /usr/local/share/openocd/scripts/interface/stlink.cfg \
  -f /usr/local/share/openocd/scripts/target/stm32f4x.cfg \
  -c "adapter speed 1000" \
  -c "init" \
  -c "reset init" \
  -c "stm32f2x mass_erase 0" \
  -c "flash write_image erase build/HMT26_FIRMWARE.elf" \
  -c "verify_image build/HMT26_FIRMWARE.elf" \
  -c "reset run" \
  -c "shutdown"
```

Then check with
```
openocd \
  -f /usr/local/share/openocd/scripts/interface/stlink.cfg \
  -f /usr/local/share/openocd/scripts/target/stm32f4x.cfg \
  -c "init; reset halt; mdw 0x08000000 16; shutdown"
```

should be:
1. First word: 0x200xxxxx (stack pointer)
2. Second word: 0x0800xxxx (Reset_Handler)


### OpenOCD Script Locations
Inside the container: ```/usr/local/share/openocd/scripts/```
```
interface/stlink.cfg
target/stm32f4x.cfg
```






### Notes

Then flash with
```
openocd \
  -f interface/stlink.cfg \
  -f target/stm32f4x.cfg \
  -c "program build/HMT26_FIRMWARE.elf verify reset exit"
```

```
openocd \
  -f interface/stlink.cfg \
  -c "transport select swd" \
  -f target/stm32f4x.cfg \
  -c "program build/Debug/compute-module.elf verify reset exit"

```


OpenOCD scripts location

In this environment:
```
/usr/local/share/openocd/scripts
```

key files
```angular2html
interface/stlink.cfg
interface/stlink-hla.cfg
target/stm32f4x.cfg
```

```angular2html
openocd \
  -f /usr/local/share/openocd/scripts/interface/stlink.cfg \
  -f /usr/local/share/openocd/scripts/target/stm32f4x.cfg \
  -c "init; reset halt; exit"
```

```angular2html
openocd \
  -f /usr/local/share/openocd/scripts/interface/stlink.cfg \
  -f /usr/local/share/openocd/scripts/target/stm32f4x.cfg \
  -c "program build/HMT26_FIRMWARE.elf verify reset exit"
```



## Credits
Template created by Daan Posthumus. Edited by Erik van Weelderen.

## License
Feel free to use it.
