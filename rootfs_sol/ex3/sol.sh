# [host] montam imaginea originala
sudo mount $HOME/rpi/rootfs-orig.img orig

# [host] montam imaginea noua
sudo mount -o offset=$((206848 * 512)) rpi.img new

# [host] copiem continutul din imaginea originala in cea noua
sudo cp -a orig/* new/

# [host] demontam cele 2 imagini
sudo umount orig
sudo umount new
