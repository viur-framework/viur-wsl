#The base image
FROM ubuntu:22.04

ARG USER

# Install required applications for the script to run
RUN apt-get update -y && apt-get -y install python3-pip curl wget passwd sudo git

# pipenv
RUN pip3 install pipenv
RUN apt-get install -y zlib1g-dev bzip2-doc libbz2-dev libncurses-dev libncursesw5-dev

# Für libreadline-dev benötigte Packages
RUN apt-get install -y binfmt-support icu-devtools libclang-cpp14 libedit2 libffi-dev libicu-dev libicu70 libllvm14 \
    libpfm4 libpipeline1 libxml2 libxml2-dev libyaml-0-2 libz3-4 libz3-dev llvm-14 llvm-14-dev llvm-14-linker-tools  \
    llvm-14-runtime llvm-14-tools llvm-runtime python3-pygments python3-yaml libreadline-dev libsqlite3-dev llvm

# weird Bunch of sub-sub-sub dependencys, this is an Artifact from development
RUN apt-get install -y libbrotli-dev libdrm-amdgpu1 libdrm-common libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 \
    libdrm2 libelf1 libfontconfig-dev libfontconfig1-dev libfontenc1 libfreetype-dev libfreetype6-dev libgl1 \
    libgl1-amber-dri libgl1-mesa-dri libglapi-mesa libglib2.0-0 libglib2.0-data libglvnd0 libglx-mesa0 libglx0 \
    libice6 libllvm13 libpciaccess0 libpng-dev libpng-tools libpthread-stubs0-dev libsensors-config libsensors5  \
    libsm6

# REGION
# weird Bunch of sub-sub-sub dependencys, this is an Artifact from development
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
    libtcl8.6 libtk8.6 libutempter0 libvulkan1 libwayland-client0 libx11-dev libx11-xcb1 libxau-dev libxaw7 \
    libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-randr0 libxcb-shape0 libxcb-shm0 libxcb-sync1 \
    libxcb-xfixes0 libxcb1-dev libxcomposite1 libxdmcp-dev libxext-dev libxext6 libxfixes3 libxft-dev libxft2 \
    libxi6 libxinerama1 libxkbfile1 libxmu6 libxmuu1 libxrandr2 libxrender-dev libxrender1 libxshmfence1 libxss-dev \
    libxss1 libxt6 libxtst6 libxv1 libxxf86dga1 libxxf86vm1 mesa-vulkan-drivers pkg-config shared-mime-info \
    tcl tcl-dev tcl8.6 tcl8.6-dev tk tk8.6 tk8.6-dev tzdata uuid-dev x11-common x11-utils x11proto-core-dev \
    x11proto-dev xbitmaps xdg-user-dirs xorg-sgml-doctools xterm xtrans-dev

RUN apt-get install -y tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Add default .bashrc for new user
COPY --chown=$USER:root ./resources/bashrc /home/${USER}/.bashrc

# NODE + npm + npm
RUN apt-get install -y nodejs npm
RUN npm install -g n
RUN n latest
RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm

# GCLoud Installement
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install -y apt-transport-https ca-certificates gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

RUN apt-get update && apt-get install -y google-cloud-sdk
RUN apt-get install -y google-cloud-sdk-app-engine-python \
    google-cloud-sdk-app-engine-python-extras  \
    google-cloud-sdk-datastore-emulator google-cloud-sdk-datastore-emulator

# Pyenv
RUN cd ~
RUN apt-get install -y make build-essential libssl3 libssl-dev xz-utils

# Add current user to environment
RUN /bin/bash -c 'useradd -m -s /bin/bash -g root ${USER}; echo "${USER}:PassW0rd" | chpasswd'
RUN /bin/bash -c "chown -cR ${USER}:root /home/${USER}"

# Add wsl settings to change mount point and default user
COPY ./resources/wsl.conf /etc/wsl.conf
COPY --chown=$USER:root ./resources/bashrc /home/${USER}/.bashrc
RUN /bin/bash -c 'echo "default=${USER}" >> /etc/wsl.conf; echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers;'

# Set the default user
USER $USER
RUN cd ~
RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash