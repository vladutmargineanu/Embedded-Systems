# [host] rulam distributia cu interfata seriala si linia de comanda a kernelului modificata
qemu-system-arm -machine versatilepb -cpu arm1176 -kernel <kernel file> -append "console=ttyAMA0 root=/dev/sda2" -drive file=<rootfs file>,index=0,media=disk,format=raw -serial stdio

# output-ul de bootare s-a mutat pe interfata seriala

# [host] adaugam si parametru console=ttyS1 liniei de comanda a kernelulului
qemu-system-arm -machine versatilepb -cpu arm1176 -kernel <kernel file> -append "console=tty1 console=ttyAMA0 root=/dev/sda2" -drive file=<rootfs file>,index=0,media=disk,format=raw -serial stdio

# output-ul de bootare apare acum si pe interfata seriala si in fereastra QEMU
