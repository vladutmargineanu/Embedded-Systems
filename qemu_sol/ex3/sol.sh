# [host] copiem kernel-ul si rootfs-ul pentru emulare
wget https://dl.dropboxusercontent.com/u/8005344/zImage-qemu
wget https://dl.dropboxusercontent.com/u/8005344/2015-05-05-raspbian-wheezy-qemu.zip

# [host] rulam distributia in QEMU
qemu-system-arm -machine versatilepb -cpu arm1176 -kernel <kernel file> -append "root=/dev/sda2" -drive file=<rootfs file>,index=0,media=disk,format=raw
