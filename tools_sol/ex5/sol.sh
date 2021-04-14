# [host] compilam pentru host
make

# [host] compilam pentru rpi
make CROSS_COMPILE=arm-linux-gnueabihf-

# [host] compilam pentru galileo
make CROSS_COMPILE=i586-poky-linux-uclibc- CFLAGS=--sysroot=<toolchain galileo>/sysroots/i586-poky-linux-uclibc/
