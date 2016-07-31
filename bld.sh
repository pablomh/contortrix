#!/bin/bash

# $1 is device codename (according to $OUT folder)
# $2 is specific output target (eg recoveryimage)

XPERIA_DATE=$(date -u +%Y%m%d)

BUILDCODE=$1
BUILDTYPE="userdebug"

if [[ $1 =~ .*user.* ]]; then
    BUILDCODE=${1::-5}
    BUILDTYPE="user"
fi

if [[ $1 =~ .*eng.* ]]; then
    BUILDCODE=${1::-4}
    BUILDTYPE="eng"
fi

case $BUILDCODE in

    # Loire Devices
    "suzu")
        XPERIA_TARGET=aosp_f5121
        ;;

    # Kitakami Devices
    "satsuki")
        XPERIA_TARGET=aosp_e6853
        ;;
    "sumire")
        XPERIA_TARGET=aosp_e6653
        ;;
    "suzuran")
        XPERIA_TARGET=aosp_e5823
        ;;
    "ivy")
        XPERIA_TARGET=aosp_e6553
        ;;
    "karin")
        XPERIA_TARGET=aosp_sgp771
        ;;
    "karin_windy")
        XPERIA_TARGET=aosp_sgp712
        ;;

    # Kanuti Devices
    "tulip")
        XPERIA_TARGET=aosp_e2303
        ;;

    # Shinano Devices
    "leo")
        XPERIA_TARGET=aosp_d6603
        ;;
    "aries")
        XPERIA_TARGET=aosp_d5803
        ;;
    "sirius")
        XPERIA_TARGET=aosp_d6503
        ;;
    "scorpion")
        XPERIA_TARGET=aosp_sgp621
        ;;
    "scorpion_windy")
        XPERIA_TARGET=aosp_sgp611
        ;;
    "castor")
        XPERIA_TARGET=aosp_sgp521
        ;;
    "castor_windy")
        XPERIA_TARGET=aosp_sgp511
        ;;

    # Rhine Devices
    "honami")
        XPERIA_TARGET=aosp_c6903
        ;;
    "amami")
        XPERIA_TARGET=aosp_d5503
        ;;
    "togari")
        XPERIA_TARGET=aosp_c6833
        ;;

    *)
        echo "Wait, what? \"$BUILDCODE\" is not a valid build target!"
        echo ""
        exit -1
    ;;
esac

CORE_COUNT=`grep processor /proc/cpuinfo | wc -l`

# Initialize environment
source build/envsetup.sh
export LANG=C
unset _JAVA_OPTIONS
export BUILD_NUMBER=$(date --utc +%Y.%m.%d.%H.%M.%S)
export DISPLAY_BUILD_NUMBER=true
export ANDROID_HOME=~/android-sdk-linux/

# Initialize the device
lunch $XPERIA_TARGET-$BUILDTYPE

# Make ALL the things!
make $2 -j$((CORE_COUNT + 2))

if [ -f out/dist/$XPERIA_TARGET-img-*.zip ]; then
    echo "Copying $BUILDCODE-CopperheadOS-$XPERIA_DATE.zip to ~/IMG"
    echo ""
    rm ~/IMG/$BUILDCODE-CopperheadOS-*.zip
    # Actually we're doing a hard link so we can immediately
    # remove the $OUT folder and build another device.
    ln out/dist/$XPERIA_TARGET-img-*.zip ~/IMG/$BUILDCODE-CopperheadOS-$XPERIA_DATE.zip
fi
