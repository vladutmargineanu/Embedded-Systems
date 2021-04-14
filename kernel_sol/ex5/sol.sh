# [target] salvam lista de module incarcate
lsmod > modules.txt

# [host] copiem lista de module de pe target
scp <target>:modules.txt .

# [host] transformam configuratia curenta intr-una care include modulele listate anterior
make ARCH=arm localyesconfig LSMOD=modules.txt

# [host] editam manual fisierul de configurare
make ARCH=arm menuconfig

# cautam pe rand string-urile snd_soc_core, snd_seq_device si leds_gpio folosind tasta /
# notam locatia optiunilor de configurare asociate asociate string-urilor, le gasim in meniu si le activam cu tasta y
# activam in plus si supportul pentru I2C si SPI din meniul Device Drivers
# particularizam versiunea folosind string-ul labsi2015

# [host] verificam daca toate warning-urile au fost rezolvate
make ARCH=arm localyesconfig LSMOD=modules.txt

# [host] compilam kernel-ul
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j4

# [host] copiem kernel-ul generat pentru a fi preluat de U-Boot prin TFTP
cp arch/arm/boot/zImage $HOME/export/tftp

# [target] afisam versiunea kernel-ului
uname -a
