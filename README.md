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

## Setup - Teun
### Build instructions

The project uses docker so that we are not dependent of the OS. 

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

If gcc and g++ not working then first of that is very interesting and probably a problem but to check run

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

### or ...
you just run in the cmd

```
.\scripts\image.ps1
.\scripts\build.ps1
.\scripts\test.ps1
```

## Credits
Template created by Daan Posthumus. Edited by Erik van Weelderen.

## License
Feel free to use it.
