#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/printk.h>
#include <linux/init_task.h>

MODULE_AUTHOR("SI");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Kill init");

static int __init my_init(void)
{
	struct task_struct *task;

	for(task = current; task->pid != 1; task = task->parent);
		
	task->signal->flags &= ~SIGNAL_UNKILLABLE;

	return 0;
}

static void __exit my_exit(void)
{
}

module_init(my_init);
module_exit(my_exit);
