# [host] rulam distributia cu o interfata seriala
qemu-system-arm -machine versatilepb -cpu arm1176 -kernel <kernel file> -append "root=/dev/sda2" -drive file=<rootfs file>,index=0,media=disk,format=raw -serial stdio

# a aparut un al doilea ecran de login in terminalul din care am rulat QEMU (stdio)
