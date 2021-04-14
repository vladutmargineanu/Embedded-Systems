# [host] configuram adresa ip cauta de target
sudo ip addr add 10.0.0.10<x>/24 dev em1

# [host] populam calea cautata target cu rootfs-ul, montand imaginea in acea locatie
sudo mount $HOME/rpi/rootfs-orig.img $HOME/export/nfs

# [host] exportam calea pentru clienti NFS
sudo exportfs -o no_root_squash,rw *:$HOME/export/nfs

# [host] testam connectarea la target, dupa trecerea timpului de boot
ssh pi@10.0.0.<x>
