#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/gpio.h>

MODULE_AUTHOR("SI");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("GPIO stuff");

#define LED_ACT 16
#define OFF 1
#define ON 0

static int __init my_init(void)
{
	gpio_direction_output(LED_ACT, OFF);

	gpio_set_value(LED_ACT, ON);

	return 0;
}

static void __exit my_exit(void)
{
	gpio_set_value(LED_ACT, OFF);
}

module_init(my_init);
module_exit(my_exit);
