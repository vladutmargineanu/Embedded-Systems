KDIR = /home/andrei/Politehnica/anul_V/SI/linux

kbuild:
	make -C $(KDIR) M=`pwd`

clean:
	make -C $(KDIR) M=`pwd` clean
	-rm -f *~ Module.symvers Module.markers modules.order
