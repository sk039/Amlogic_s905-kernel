#!/bin/sh

export ARCH=arm64
export CROSS_COMPILE=/opt/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin/aarch64-none-elf-
#OUTPUT=build-phicomm-n1
INSTALL_TMP=./_install

if [ ! -x ${CROSS_COMPILE}gcc ]; then
    wget -c http://openlinux.amlogic.com:8000/deploy/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar
    sudo tar -xf gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar -C /opt
fi

#if [ ! -d $OUTPUT ]; then mkdir -p $OUTPUT; fi
#if [ ! -f $OUTPUT/.config ]; then cp config-n1-20180629 $OUTPUT/.config; fi
if [ ! -f .config ]; then cp config-n1-20180629 .config; fi

#make O=$OUTPUT $@
if [ "x$@" != "x" ]; then
    make $@
    exit 0
fi

make Image
make gxl_p230_2g.dtb
cp arch/arm64/boot/Image arch/arm64/boot/dts/amlogic/gxl_p230_2g.dtb .

make modules
make modules_install INSTALL_MOD_PATH=$INSTALL_TMP
make firmware_install INSTALL_MOD_PATH=$INSTALL_TMP
cd $INSTALL_TMP
tar -cjf ../modules_firmware.tar.bz2 .
cd -
rm -rf $INSTALL_TMP

