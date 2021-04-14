# [host] dezasamblam executabilul pentru host
objdump -D hello.host

# [host] dezasamblam executabilul pentru rpi
arm-linux-gnueabihf-objdump -D hello.rpi

# [host] dezasamblam executabilul pentru galileo
i586-poky-linux-uclibc-objdump -D hello.galileo

# observam seturile de instructiuni diferite folosite de x86 si ARM
# observam ca desi host-ul si galileo folosesc instruciuni asemanatoare, cele doua executabile arata foarte diferit din cauza compilatoarelor diferite folosite pentru a genera executabilele
