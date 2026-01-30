FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

# Update CMake to the latest version
RUN apt-get update && \
    apt-get install -y wget && \
    wget -qO- "https://github.com/Kitware/CMake/releases/download/v3.27.9/cmake-3.27.9-linux-x86_64.sh" > /tmp/cmake.sh && \
    bash /tmp/cmake.sh --skip-license --prefix=/usr/local && \
    rm /tmp/cmake.sh

# Install build dependencies for OpenOCD and general tools
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    python3 \
    python3-pip \
    make \
    xz-utils \
    tar \
    pkg-config \
    libtool \
    autoconf \
    automake \
    texinfo \
    libusb-1.0-0-dev \
    libftdi1-dev \
    libhidapi-dev \
    libjaylink-dev \
    libftdi1-dev \
    && rm -rf /var/lib/apt/lists/*

# Build jimTcl
RUN git clone https://github.com/msteveb/jimtcl.git /tmp/jimtcl && \
    cd /tmp/jimtcl && \
    ./configure && make -j$(nproc) && make install && \
    rm -rf /tmp/jimtcl

# Build and install OpenOCD from source (latest master)
RUN git clone --recursive https://github.com/openocd-org/openocd.git /tmp/openocd && \
    cd /tmp/openocd && \
    ./bootstrap && \
    ./configure --enable-stlink --enable-cmsis-dap --disable-werror && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/openocd

# Install ARM GNU Toolchain
RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu/14.3.rel1/binrel/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi.tar.xz \
    | tar -xJ -C /opt && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-gcc && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-g++ /usr/bin/arm-none-eabi-g++ && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-ld /usr/bin/arm-none-eabi-ld && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-objcopy /usr/bin/arm-none-eabi-objcopy && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-objdump /usr/bin/arm-none-eabi-objdump && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-nm /usr/bin/arm-none-eabi-nm && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-size /usr/bin/arm-none-eabi-size && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-ar /usr/bin/arm-none-eabi-ar && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-as /usr/bin/arm-none-eabi-as && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-gdb /usr/bin/arm-none-eabi-gdb && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-ranlib /usr/bin/arm-none-eabi-ranlib && \
    ln -s /opt/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-strip /usr/bin/arm-none-eabi-strip

FROM base AS templatespecific
# Install pre-commit: https://pre-commit.com/
RUN apt-get update && apt-get install pipx -y && \
    pipx ensurepath && \
    pipx install pre-commit

# Install LLVM (includes clang)
RUN apt-get update && apt-get install -y \
    llvm \
    clang \
    && rm -rf /var/lib/apt/lists/*

# Install uncrustify
RUN apt-get update && apt-get install -y \
    uncrustify \
    && rm -rf /var/lib/apt/lists/*

# Install cppcheck
RUN apt-get update && apt-get install -y \
    cppcheck \
    && rm -rf /var/lib/apt/lists/*

# TODO: Fix IWYU
# RUN git clone https://github.com/include-what-you-use/include-what-you-use.git /tmp/iwyu && \
#     cd /tmp/iwyu && \
#     mkdir build && cd build \
#     cmake -G "Unix Makefiles" -DCMAKE_PREFIX_PATH=/usr/lib/llvm ../iwyu \
#     make install \
#     rm -rf /tmp/iwyu
    # TODO: add to path

# --------------------
# Install OCLint
# --------------------

ENV OCLINT_VERSION=24.11

RUN wget -q \
    https://github.com/oclint/oclint/releases/download/v24.11/oclint-24.11-llvm-16.0.4-x86_64-linux-ubuntu-24.04.tar.gz \
    -O /tmp/oclint.tar.gz \
    && mkdir -p /opt/oclint \
    && tar -xzf /tmp/oclint.tar.gz \
        --no-same-owner \
        --no-same-permissions \
        -C /opt \
    && ln -s /opt/oclint-${OCLINT_VERSION}/bin/oclint /usr/local/bin/oclint \
    && ln -s /opt/oclint-${OCLINT_VERSION}/bin/oclint-json-compilation-database /usr/local/bin/oclint-json-compilation-database \
    && rm /tmp/oclint.tar.gz


# Verify installs (optional but useful)
RUN llvm-config --version \
    && uncrustify --version \
    && cppcheck --version \
    # && include-what-you-use --version
    && oclint --version
    

# Add VSCode user
RUN useradd -ms /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER vscode

WORKDIR /workspaces
RUN chown -R vscode:vscode /workspaces
