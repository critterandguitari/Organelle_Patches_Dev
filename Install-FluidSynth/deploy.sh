#!/bin/bash

echo "Updating OS"

# check file integrity
if openssl sha1 /usbdrive/Patches/Install-FluidSynth/libfluidsynth.so | grep "da446ecb6d62f915f85d6002c721f6a92bb212b1"; then
    echo "file checks out"
else
    echo "error 1"
    exit 1
fi

if openssl sha1 /usbdrive/Patches/Install-FluidSynth/libfluidsynth.so.1 | grep "da446ecb6d62f915f85d6002c721f6a92bb212b1"; then
    echo "file checks out"
else
    echo "error 1"
    exit 1
fi

if openssl sha1 /usbdrive/Patches/Install-FluidSynth/libfluidsynth.so.1.5.2 | grep "da446ecb6d62f915f85d6002c721f6a92bb212b1"; then
    echo "file checks out"
else
    echo "error 1"
    exit 1
fi

if openssl sha1 /usbdrive/Patches/Install-FluidSynth/fluidsynth | grep "d5ca1b1f5f6f7c2d7f71f6c18bad5f798315466a"; then
    echo "file checks out"
else
    echo "error 1"
    exit 1
fi


# remount root read write
/root/scripts/remount-rw.sh

# copy files
cp -f /usbdrive/Patches/Install-FluidSynth/libfluidsynth* /usr/lib
cp -f /usbdrive/Patches/Install-FluidSynth/fluidsynth /usr/bin

# sync
sync 

# just chill
sleep 1

# let pd know
echo "Sucess 1"

exit 0
# normally we'd want to remount read only, but this is not possible because of cp -f
# but pd patch will call shutdown after this anyway
