#!/bin/bash

set -e

ANDROID_HOME=/opt/android-sdk
CMDLINE_TOOLS_INSTALL_FILENAME=cmdline-tools
CMDLINE_TOOLS_DIRECTORY=${ANDROID_HOME}/${CMDLINE_TOOLS_INSTALL_FILENAME}
SDK_PACKAGE="system-images;android-33;google_apis_playstore;x86_64"

function check_root {
    if [ "$EUID" -eq 0 ]; then
        echo "Cannot run this script as root user"
        exit 1
    fi
}

function install_openjdk {
    sudo apt install -y default-jdk
}

function install_cmdline_tools {
    INSTALL_DIRECTORY=/tmp/KIFMangaNotif/installer
    CMDLINE_TOOLS_INSTALL=https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip
    
    mkdir -p $INSTALL_DIRECTORY
    wget -O ${INSTALL_DIRECTORY}/${CMDLINE_TOOLS_INSTALL_FILENAME}.zip $CMDLINE_TOOLS_INSTALL
    unzip -o ${INSTALL_DIRECTORY}/${CMDLINE_TOOLS_INSTALL_FILENAME}.zip -d ${INSTALL_DIRECTORY}
    sudo rm -rf ${ANDROID_HOME}
    sudo mkdir -p ${CMDLINE_TOOLS_DIRECTORY}
    sudo mv -v ${INSTALL_DIRECTORY}/${CMDLINE_TOOLS_INSTALL_FILENAME} ${ANDROID_HOME}/cmdline-tools
    sudo mv ${CMDLINE_TOOLS_DIRECTORY}/cmdline-tools ${CMDLINE_TOOLS_DIRECTORY}/latest

    export ANDROID_HOME=$ANDROID_HOME
    export ANDROID_SDK_ROOT=$ANDROID_HOME
    export PATH+=:${CMDLINE_TOOLS_DIRECTORY}/latest/bin

    sudo chown $USER:$USER $ANDROID_HOME -R

    if ! sdkmanager --version >/dev/null 2>&1; then
        >&2 echo "Failed to download android cmdline tools"
        exit 1
    fi
}

function setup_sdk_manager {
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.1"
    sdkmanager "emulator"
    sdkmanager ${SDK_PACKAGE}
}

function setup_avd_manager {
    echo no | avdmanager create avd --force --name KIFMangaNotif --abi google_apis_playstore/x86_64 --package "${SDK_PACKAGE}"
}

check_root
if ! sdkmanager >/dev/null 2>&1; then
    install_openjdk
    install_cmdline_tools
fi
setup_sdk_manager
setup_avd_manager

