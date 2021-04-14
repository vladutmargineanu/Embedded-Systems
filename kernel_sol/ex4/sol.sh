# [host] schimbam repository-ul pe branch-ul rpi-3.12.y, folosim -f pentru a forta schimbarea si pierde modificarile efectuate anterior in repository
git checkout rpi-3.12.y -f

# [host] curatam fisierele binare generate anterior
make clean

# [host] aflam numele configurarii implicte quick pentru RaspberryPi
make ARCH=arm help | grep quick

# [host] generam fisierul de configurare implicita quick
make ARCH=arm bcmrpi_quick_defconfig

# [host] compilam kernel-ul
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4

# [host] copiem kernel-ul generat pentru a fi preluat de U-Boot prin TFTP
cp arch/arm/boot/zImage $HOME/export/tftp

# [target] afisam versiunea kernel-ului
uname -a
