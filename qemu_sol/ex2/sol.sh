# [host] compilam pentru RaspberryPi
arm-linux-gnueabihf-gcc -static hello.c -o hello

# [host] afisam informatiile despre continutul fisierului rezultat
file hello

# setul de instructiuni este ARM, 32 biti

# [host] rulam cu QEMU si emulam procesorul ARM1176
qemu-arm -cpu arm1176 hello

# [host] rulam direct
./hello

# la instalare, QEMU se inregistreaza automat ca intrepretor pentru executabilele non-native
# pentru mai multe detalii vedeti documentatia acestui feature https://www.kernel.org/doc/Documentation/binfmt_misc.txt
