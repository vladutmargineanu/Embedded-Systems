# [host] compilam
gcc hello.c -o hello

# [host] rulam executabilul
./hello

# [host] ne conectam pe seriala la galileo
screen /dev/ttyACM0 115200

# [galileo] aflam ip-ul
ifconfig

# [host] copiem executabilul pe galileo
scp hello root@<galileo>:

# [host] ne conectam prin ssh la galileo
ssh root@<galileo>

# [galileo] rulam executabilul
./hello

# [host] copiem executabilul pe rpi
scp hello pi@<pi>:

# [host] ne conectam la rpi
ssh pi@<pi>

# [rpi] rulam executabilul
./hello
