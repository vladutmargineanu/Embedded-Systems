# [host] instalam cross-compilerul pentru rpi
git clone --depth=1 https://github.com/raspberrypi/tools.git
cp -r tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/ toolchain-rpi/
rm -rf tools/
export PATH=<toolchain rpi>/bin/:$PATH

# [host] compilam pentru rpi
arm-linux-gnueabihf-gcc hello.c -o hello

# [host] copiem executabilul pe rpi
scp hello pi@<pi>:

# [host] ne conectam pe rpi
ssh pi@<pi>

# [rpi] rulam executabilul
./hello
