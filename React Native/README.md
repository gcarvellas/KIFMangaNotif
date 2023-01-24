# KIFMangaNotif Frontend (React Native)

## Requirements

- yarn

## Running React Native Web (Not recommended for development)

### First-Time Setup
1. Run `yarn install`. You only need to run this once.

## Running React Native Android

### First-Time Setup (With Linux Shell Script)

1. Run `apt update`
2. Run `bash install_android_vm.sh` and wait for the installer to finish. This may take a while
3. Open your VM with `/opt/android-sdk/emulator/emulator -avd KIFMangaNotif`

### Starting

1. Make sure your vm is open
2. Run `ANDROID_HOME=/opt/android-sdk yarn run android`