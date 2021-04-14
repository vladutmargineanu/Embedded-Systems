# [host] cream fisierul pentru imagine 3*2014 blocuri a 1MB fiecare -> 3GB
dd if=/dev/zero of=rpi.img count=3k bs=1M

# [host] cream tabela de partii si cele doua partitii, de 100MB si restul spatiului
# comenzile pentru fdisk sunt transmise cu ajutorul echo fiecare \n reprezentand un Enter
echo -ne "n\np\n1\n\n+100M\nn\np\n2\n\n\nw\n" | fdisk rpi.img

# [host] cream un fisier pentru continutul primei partitii
dd if=/dev/zero of=boot.img count=204800 bs=512

# [host] cream sistemul de fisiere pe prima partitie
mkfs -t vfat boot.img

# [host] cream un fisier pentru continutul celei de-a doua partitii
dd if=/dev/zero of=rootfs.img count=6084608 bs=512

# [host cream sistemul de fisiere pentru a doua partitie
mkfs -t ext2 rootfs.img

# [host] copiem continutul celor 2 partitii in locatiile corespunzatoare din imaginea completa
dd if=boot.img of=rpi.img bs=512 seek=2048
dd if=rootfs.img of=rpi.img bs=512 seek=206848
