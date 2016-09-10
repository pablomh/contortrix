#!/bin/bash

# $1 is device codename (according to $OUT folder)
# $2 is specific output target (eg recoveryimage)

case $1 in

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

    *)
        echo "Wait, what? \"$1\" is not a valid build target!"
        echo ""
        exit -1
        ;;
esac

# Initialize environment
source build/envsetup.sh

# Initialize the device
lunch $XPERIA_TARGET-userdebug

# Run audit2allow
./external/selinux/prebuilts/bin/audit2allow -p out/target/product/$1/root/sepolicy -i $2
