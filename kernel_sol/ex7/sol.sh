# [host] schimbam repository-ul pe branch-ul rpi-3.18.y
git checkout rpi-3.18.y

# [host] transplantam commit-ul care contine fisierul de configurare dorit
git cherry-pick eff92148ee1b5a1ff07e5817179fefb4a0562b17

# [host] curatam fisierele binare generate anterior
make clean

# [host] cream fisierul de configurare implicita quick
make ARCH=arm bcmrpi_quick_defconfig

# [host] actualizam fisierul de configurare pentru versiunea 3.18
make ARCH=arm silentoldconfig

# raspundem cu 0 la valoarea pentru PHYS_OFFSET

# [host] compilam kernel-ul
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4

# [host] identificam fisierele care contin simbolul nedefinit mmc_debug
grep -nHR mmc_debug

# observam ca el este definit intr-un singur fisier: drivers/mmc/host/bcm2835-mmc.c

# [host] editam manual configuratia si cautam optiuni legate de MMC
make ARCH=arm menuconfig

# observam ca optiunea MMC_BCM2835 este dezactivata si o activam

# [host] reluam compilarea
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4

# [host] copiem kernel-ul generat pentru a fi preluat de U-Boot prin TFTP
cp arch/arm/boot/zImage $HOME/export/tftp

# [target] afisam versiunea kernel-ului
uname -a
