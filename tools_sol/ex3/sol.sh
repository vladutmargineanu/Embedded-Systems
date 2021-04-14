# [host] instalam cross-compilerul pentru galileo
wget https://downloadmirror.intel.com/24355/eng/IntelArduino-1.6.0-Linux64.txz
tar xJf IntelArduino-1.6.0-Linux64.txz
cp -r arduino-1.6.0+Intel/hardware/tools/i586/ toolchain-galileo/
rm -rf arduino-1.6.0+Intel/ IntelArduino-1.6.0-Linux64.txz
cd toolchain_galileo
sed -i -e "s/-perm\s+\+111/-perm \/111/g" install_script.sh
./install_script.sh
export PATH=<toolchain galileo>/sysroots/pokysdk/usr/bin/i586-poky-linux-uclibc/:$PATH

# [host] compilam pentru galileo
i586-poky-linux-uclibc-gcc --sysroot=<toolchain galileo>/sysroots/i586-poky-linux-uclibc/ hello.c -o hello

# [host] copiem executabilul pe galileo
scp hello root@<galileo>:

# [host] ne conectam pe galileo
ssh root@<galileo>

# [galileo] rulam executabilul
./hello
