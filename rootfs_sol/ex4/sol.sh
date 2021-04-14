# [host] un-exportam locatiile anterioare
sudo exportfs -ua

# [host] demontam imaginea originala
sudo umount $HOME/export/nfs

# [host] montam noua imagine
sudo mount -o offset=$((206848 * 512)) rpi.img $HOME/export/nfs

# [host] exportam noul rootfs
sudo exportfs -o no_root_squash,rw *:$HOME/export/nfs

# [host] testam connectarea la target, dupa trecerea timpului de boot
ssh pi@10.0.0.<x>
