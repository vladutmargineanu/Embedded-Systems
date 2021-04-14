# [host] rulam sistemul emulat cu interfata de retea legata la reteaua fizica
qemu-system-arm -machine versatilepb -cpu arm1176 -kernel <kernel file> -append "root=/dev/sda2" -drive file=<rootfs file>,index=0,media=disk,format=raw -net nic,model=smc91c111,netdev=bridge -netdev bridge,br=virbr0,id=bridge

# [guest] test conectivitatea la internet
ping www.google.com
