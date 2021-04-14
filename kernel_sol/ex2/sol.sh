# [host] schimbam repository-ul pe branch-ul rpi-3.18.y
git checkout rpi-3.18.y

# [host] aplicam patch-ul pentru activarea arhitecturii ARMv6 pt Versatile PB
patch -p1 < linux-rpi-3.18.y-armv6.patch

# [host] generam fisierul de configurare implicita pentru Versatile PB
make ARCH=arm versatile_defconfig

# [host] aplicam patch-ul pentru a modifica fisierul de configurare pentru QEMU
patch -p1 < linux-rpi-3.18.y-qemu.patch

# [host] compilam kernelul
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4

# [host] rulam in QEMU si selectam finish in ecranul inital de configurare
qemu-system-arm -machine versatilepb -cpu arm1176 -kernel arch/arm/boot/zImage -append "root=/dev/sda2" -drive file=<rootfs file>,index=0,media=disk,format=raw

# [guest] afisam versiunea kernel-ului
uname -a
