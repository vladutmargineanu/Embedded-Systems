ARCH := arm
CROSS_COMPILE := arm-linux-gnueabihf-

KDIR := /opt/rpi/kernel

PWD := $(shell pwd)

obj-m := epiclock.o

kbuild:
	make -C $(KDIR) M=`pwd` ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules

clean:
	make -C $(KDIR) M=`pwd` clean
	-rm -f *~ Module.symvers Module.markers modules.order

