#include <fcntl.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/types.h>

#include <stdio.h>


int main(void)
{
	int dev;

	if((dev = open("/dev/led_act", O_WRONLY)) < 0)
	{
		perror("error opening device file\n");
		return 1;
	}

	for(;;)
	{
		write(dev, "0", 1);
		usleep(500000);

		write(dev, "1", 1);
		usleep(500000);
	}

	close(dev);

	return 0;
}

