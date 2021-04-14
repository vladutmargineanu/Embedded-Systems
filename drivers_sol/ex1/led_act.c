#include <linux/atomic.h>
#include <linux/fs.h>
#include <linux/gpio.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/printk.h>
#include <linux/uaccess.h>

MODULE_DESCRIPTION("RaspberryPI ACT LED driver");
MODULE_AUTHOR("SI");
MODULE_LICENSE("GPL");

static int open(struct inode *, struct file *);
static int release(struct inode *, struct file *);
static int read(struct file *file, char __user *user_buffer, size_t size, loff_t *offset);
static int write(struct file *file, const char __user *user_buffer, size_t size, loff_t *offset);

static struct file_operations fops = {
	.open = open,
	.release = release,
	.read = read,
	.write = write,
};

static int major;	// our assigned major number
static atomic_t used;	// 0 - led is available, 1 - led is already opened
static int state;	// 0 - led is off, 1 - led is on

static int __init init(void)
{
	// led is unused
	atomic_set(&used, 0);

	// led is off
	state = 0;
	gpio_request(16, "led_act");
	gpio_direction_output(16, !state);

	// register as chardev and get our major number
	if((major = register_chrdev(0, "led_act", &fops)) < 0)
		return major;

	return 0;
}

static void __exit exit(void)
{
	// we are no longer servicing chardev requests
	unregister_chrdev(major, "led_act");

	gpio_free(16);
}

static int open(struct inode *inode, struct file *file)
{
	// led becomes used if it was previously unused, otherwise EPERM
	if(atomic_cmpxchg(&used, 0, 1) != 0)
		return -EPERM;

	return 0;
}

static int release(struct inode *inode, struct file *file)
{
	int old_used;

	// led becomes unused
	if((old_used = atomic_cmpxchg(&used, 1, 0)) != 1)
		printk(KERN_ERR "closing device that was not opened; state is %d\n", old_used);

	return 0;
}

static int read(struct file *file, char __user *user_buffer, size_t size, loff_t *offset)
{
	// UGLY HACK - ignore concurrency issues
	// even if we allow only one process to open the device
	// we can still get concurrent accesses from a multithreaded process

	// determine content and length based on state
	const char* str = state ? "on\n" : "off\n";
	size_t len = state ? 3 : 4;
	int remaining;

	// compute remaining length of content
	if(len <= *offset)
		len = 0;
	else
		len -= *offset;

	// limit size of transfer: 0 <= size <= sizeof(remainging content)
	size = min(size, len);

	// nothing to transfer
	if(size == 0)
		return 0;

	if((remaining = copy_to_user(user_buffer, str + *offset, size)) != 0)
		return -EFAULT;

	*offset += size - remaining;

	return size - remaining;
}

static int write(struct file *file, const char __user *user_buffer, size_t size, loff_t *offset)
{
	// UGLY HACK - ignore concurrency issues
	// even if we allow only one process to open the device
	// we can still get concurrent accesses from a multithreaded process

	int ret;
	char value;

	// what is a write of size 0?
	if(size == 0)
		return -EINVAL;

	if((ret = get_user(value, user_buffer) < 0))
		return ret;

	switch(value)
	{
		case '0':
			state = 0;
			break;

		case '1':
			state = 1;
			break;
	}
	gpio_set_value(16, !state);

	return 1;
}

module_init(init);
module_exit(exit);

