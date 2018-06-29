#!/bin/sh

export ARCH=arm64
export CROSS_COMPILE=/opt/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-elf/bin/aarch64-elf-
#OUTPUT=build-phicomm-n1
INSTALL_TMP=./_install

if [ ! -x ${CROSS_COMPILE}gcc ]; then
    wget -c https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/aarch64-elf/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-elf.tar.xz
    sudo tar -xf gcc-linaro-5.5.0-2017.10-x86_64_aarch64-elf.tar.xz -C /opt
fi

#if [ ! -d $OUTPUT ]; then mkdir -p $OUTPUT; fi
#if [ ! -f $OUTPUT/.config ]; then cp config-n1-20180629 $OUTPUT/.config; fi
if [ ! -f .config ]; then cp config_20180219 .config; fi

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

