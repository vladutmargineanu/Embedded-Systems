#include <linux/init.h>
#include <linux/printk.h>
#include <linux/module.h>

MODULE_AUTHOR("SI");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Hello World");

static int __init my_init(void)
{
	printk(KERN_DEBUG "Hello, world!\n");

	return 0;
}

static void __exit my_exit(void)
{
	printk(KERN_DEBUG "Goodbye, world!\n");
}

module_init(my_init);
module_exit(my_exit);
