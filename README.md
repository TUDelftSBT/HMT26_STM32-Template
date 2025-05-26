# _--New project name--_
This repo includes a setup for developing on STM32 using a custom build toolchain which allows you to use other GIT repositories as modules (can_queue and database) and insert the GIT_HASH in code.
*Please replace this by a description about the project you are working on.*

## Project setup
1. Fork this project or create a copy.
2. Open a new STM32CubeMX project and set the following settings in the project manager tab:
  - Project name: (same name as the folder/repo name)
  - Project location: (folder above the folder/repo)
  - Toolchain/IDE: STM32CubeIDE and Generate under Root enabled
3. Click generate code in the top right and run from your or my favourite IDE.
4. To create your own code, you can use the Project folder.

## Using versions
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

# Development Setup
This is the IDE setup I found most useful while developing. What are the advantages over using visual studio code with PlatformIO or arduino IDE?
- Use of a mature code editor like CLion, without the need for a complicated manual build and programming proces.

What are the tools needed?
- A git client (such as GIT bash, Sourcetree or GitKraken)
- [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html) for STM32 code generation
- [JetBrains CLion](https://www.jetbrains.com/clion/) as your IDE
- [arm-none-eabi](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads) toolchain for building the application (see image 1)
- [xPack OpenOCD](https://github.com/xpack-dev-tools/openocd-xpack/releases/) for programming and debugging the STM32 (see image 2)

## Installation
If you do the installation in this order, it should work. If you install multiple things at the same time you might need to restart CLion at the end to make it work.

### Git and repo
Download your favorite GIT client. Clone this repository to your machine with recurse submodules enabled!

### STM32CubeMX
Download STM32CubeMX from the site, create an account and log in. You should set this up like you normally would. 

### Arm-none-eabi Toolchain
Download and install the appropriate arm-eabi-none compiler which you have downloaded from the link. In the last step, click 'add to PATH variable'.

### xPack openOCD
Download the zipped file. Put it in a permanent place such as ```/documents/openOCD``` and unzip it there. You now take the contents of the OpenOCD folder and put them in a folder above. (angie, contrib, openULINK, scripts from OpenOCD to xpack-openocd-[version])

### Jetbrains CLion
Download and install CLion. You will need a account, you can do this with your student mail. Just request a student license, these are free. Now open this repository in CLion. 
1. Once opened you will get the image 3 popup. Click the plus in the top corner, add a system toolchain and under C compiler link the installed arm-none-eabi toolchain (this is located in Porgram files (x86)/Arm GNU Toolchain [version]/[release]/bin/arm-none-eabi-gcc.c). The wizard will detect the other fields automatically, so you can click okay.

2. Go to settings > Build, Execution, Deployment > Embedded development. Here you need to link OpenOCD and STM32CubeMX. For OpenOCD navigate to the folder where you installed it, and copy the link of /bin/openocd.exe (without quotes). Fill this in here and click Test. If it works, you should now see a green popup. For the STM32CubeMX copy the link to the program and enter this here, again, if done correctly this should show a green popup.

3. Once you have setup everything correctly, a CMake screen should open in the bottom of CLion (like image 5) (if it doesnt, restart CLion). Click the refresh button, at the first time it gives an error in the CMake CheckGit file, click the refresh button again and it should dissappear. You can see that a build icon has appeared in the top bar.

4. Click the build configuration in the top bar (image 6, VCU.ELF). Add a configuration with the plus in image 7, and add a OpenOCD download and run configuration. Set it up as stated in image 8.

5. You're now set to go. Click the run button and it should automatically build and deploy to STM32 if you have connected it by the STLink via USB.

## FAQ
1. I can't run CMake, it can't find the toolchain on my PATH variable? > You probably did not add the PATH correctly in the last step of installation of the toolchain, or you just need to restart CLion to update its internal path variable.
2. I cannot build, I get errors that say, there is no database.h found. > You did not recursively add the submodules. 
3. How can I configure our own DBC files? > Delete our DBC submodule under /Core/Lib/dbc and add your own Git submodule back, don't forget to fetch it.
4. How can I add the GIT hash in my code? > At built time, the file version.c is created with the hash in there. You can include it in your files by using the version.h.

## Images
Image 1:

![afbeelding](https://github.com/user-attachments/assets/960c9f21-d935-4d0a-8066-dc6a9e3352ca)

Image 2:

![afbeelding](https://github.com/user-attachments/assets/de3c74e7-c0a8-40dd-bb2f-6089b48dfc5c)

Image 3:

![afbeelding](https://github.com/user-attachments/assets/7f9c8239-4d4e-4a95-83de-faafd16bcd80)

Image 4:

![afbeelding](https://github.com/user-attachments/assets/0786d4ec-03c9-4c05-a11e-eb2c24374cc5)

Image 5:

![afbeelding](https://github.com/user-attachments/assets/3352bac8-59b6-4ea5-86ce-052336ccaa51)

Image 6:

![afbeelding](https://github.com/user-attachments/assets/8736e70a-175b-40d0-b37a-218250f0eed1)

Image 7:

![afbeelding](https://github.com/user-attachments/assets/8d2eae88-2c19-4d64-a883-4095dc58c457)

Image 8:

![afbeelding](https://github.com/user-attachments/assets/75ebcc83-1376-4abd-8b15-56331d7698a2)
