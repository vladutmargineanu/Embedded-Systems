# [host] clonam repository-ul
git clone https://github.com/raspberrypi/linux.git

# [host] listam configuratiile care contin string-urile 'versatile' sau 'bcm'
make ARCH=arm help | grep "versatile\|bcm"

# [host] generam configuratia versatile
make ARCH=arm versatile_defconfig

# [host] studiem continutul fisierului de configurare
vim .config

# observam ca este compus din linii cheie=valoare, cu majoritatea (toate?) cheilor incepand cu CONFIG_
