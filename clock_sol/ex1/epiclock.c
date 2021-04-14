#include <linux/module.h>
#include <linux/init.h>
#include <linux/gpio.h>
#include <linux/hrtimer.h>
#include <linux/ktime.h>
#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/uaccess.h>


MODULE_DESCRIPTION("Epiclock Module");
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


#define MS_TO_NS(x)	(x * 1E6L)

#define BLINK_DELAY	1

int digits[10][7] =
{
	{1,1,1,1,1,1,0},	//0
	{0,1,1,0,0,0,0},	//1
	{1,1,0,1,1,0,1},	//2
	{1,1,1,1,0,0,1},	//3
	{0,1,1,0,0,1,1},	//4
	{1,0,1,1,0,1,1},	//5
	{1,0,1,1,1,1,1},	//6
	{1,1,1,0,0,0,0},	//7
	{1,1,1,1,1,1,1},	//8
	{1,1,1,1,0,1,1},	//9
};

int seg[7] ={7,11,8,9,25,10,24};//25, 24, 23, 22, 27, 18, 17};
int en[8] = {22,23,27,18,17,15,14,4};//11, 10, 9, 8, 7, 4}; 

//-1 means show nothing, 0-9 the digits to display 
static int saved_digit[8]={-1,-1,-1,-1,-1,-1,-1,-1};

static struct hrtimer hr_timer;
static ktime_t ktime_period;


/* Enables the segments of the digit
 * /param n The number to display
 */
void digit(int n)
{
	/* sanity checks*/
	if (n < 0 || n > 9)
	{
		return;
	}
	int i;

	for(i = 0; i < 7; ++i)
		gpio_set_value(seg[i], digits[n][i]);
}

/* Enables the driver to power one of the digits
 * \param d Line of the driver to be enabled, -1 for none
 */
void enable(int d)
{
	int i;

	for(i = 0; i < 8; i++)
		if(i == d)
			gpio_set_value(en[i], 1);
		else
			gpio_set_value(en[i], 0);
}

/* Timer callback to update display
 */
enum hrtimer_restart epiclock_update(struct hrtimer* timer)
{
	static unsigned pos = 0;

	ktime_t kt_now;
	int ret;

	/* current position shown */
	if(pos < 6 && saved_digit[pos] >=0)
	{
		digit(saved_digit[pos]);	
		enable(pos);
	}
	else 
	{
		if(saved_digit[pos]>0)
			enable(pos);
		else
			enable(-1);
	}

	/* next position to show */
	pos = (pos + 1 ) % 8;

	kt_now = hrtimer_cb_get_time(&hr_timer);
	ret = hrtimer_forward(&hr_timer, kt_now, ktime_period);

	return HRTIMER_RESTART;
}

static int __init epiclock_init(void)
{
	int i;
	ktime_t ktime;

	printk(KERN_INFO "epiclock: loading\n");

	/* initialize all signals to output, but off */
	for(i = 0; i < 7; i++)
	{	
		gpio_direction_output(seg[i], 0);
	}
	for(i = 0; i < 8; i++)
	{	
		gpio_direction_output(en[i], 0);
	}
	/* set up the timer for the first time */
	

	ktime_period = ktime_set(0, MS_TO_NS(BLINK_DELAY));
	hrtimer_init(&hr_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
	hr_timer.function = epiclock_update;
	hrtimer_start(&hr_timer, ktime, HRTIMER_MODE_REL);

	// register as chardev and get our major number
	if((major = register_chrdev(0, "epic_clock", &fops)) < 0)
		return major;


	return 0;
}

static void __exit epiclock_cleanup(void)
{
	printk(KERN_INFO "epiclock: unloading...\n");

	/* disable timer */
	hrtimer_cancel(&hr_timer);

	unregister_chrdev(major, "epic_clock");

	/* disable all digits and points */
	enable(-1);
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
	return 0;

}


static int write(struct file *file, const char __user *user_buffer, size_t size, loff_t *offset)
{
	// UGLY HACK - ignore concurrency issues
	// even if we allow only one process to open the device
	// we can still get concurrent accesses from a multithreaded process

	int ret, i_value = -1,i_pos = 0;
	char c_value,c_pos;

	// what is a write of size 0?
	if(size == 0)
		return -EINVAL;

	if((ret = get_user(c_value, user_buffer) < 0))
		return ret;

	
	if((ret = get_user(c_pos, user_buffer+1) < 0))
		return ret;

	if(c_value >= '0' && c_value <='9')
	{
		i_value = c_value - '0';
	}
	
	if(c_pos >= '0' && c_pos <= '7')
	{	
		i_pos = c_pos - '0';
	}	

	printk(KERN_INFO "pos %i, value %i\n",i_pos,i_value);	

	saved_digit[i_pos]  =  i_value;

	return size;
}

module_init(epiclock_init);
module_exit(epiclock_cleanup);

