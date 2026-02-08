#include <linux/module.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include "cmds.h"

static atomic_t num = {0};

static long hello_ioctl(struct file *filp,
        unsigned int cmd, unsigned long arg)
{
    switch (cmd) {
    case INC_NUM:
        atomic_inc(&num);
        return 0;
    case GET_NUM:
        return put_user(atomic_read(&num), (int __user *)arg);
    default:
        return -ENOTTY;
    }
}

static const struct file_operations hello_fops = {
    .owner = THIS_MODULE,
    .unlocked_ioctl = hello_ioctl,
};

static struct miscdevice hello_miscdev = {
    .minor = MISC_DYNAMIC_MINOR,  // Use free number
    .name = KBUILD_MODNAME,       // Device name
    .fops = &hello_fops,          // File operations
    .mode = 0444,                 // Read only
};

static int __init hello_init(void)
{
    return misc_register(&hello_miscdev);
}

static void __exit hello_exit(void)
{
    misc_deregister(&hello_miscdev);
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
