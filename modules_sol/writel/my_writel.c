#include <linux/kernel.h>
#include <linux/module.h>
#include <asm/io.h>

MODULE_AUTHOR("SI");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("writel stuff");


static void set_output(void)
{
	void *addr = (void *)0xf2200004;
	u32 val = readl(addr);

	/* set 20-18 bits to 001 */
	writel((~(7<<18) & val) | (1<<18), addr);
}

static void led_off(void)
{
	void *addr = (void *)0xf220001c;
	writel(1<<16, addr);
}

static void led_on(void)
{
	void *addr = (void *)0xf2200028;
	writel(1<<16, addr);
}

static int __init my_init(void)
{
	set_output();
	led_on();

	return 0;
}

static void __exit my_exit(void)
{
	led_off();
}

module_init(my_init);
module_exit(my_exit);
