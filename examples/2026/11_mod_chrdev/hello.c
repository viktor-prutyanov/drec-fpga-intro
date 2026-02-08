#include <linux/module.h>
#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/uaccess.h>

static const char msg[] = "Hello from device!\n";

static ssize_t hello_read(struct file *filp,
    char __user *buf, size_t count, loff_t *pos)
{
   if (*pos > 0 || count < sizeof(msg)-1)
       return 0;
   if (copy_to_user(buf, msg, sizeof(msg)-1))
       return -EFAULT;
   return sizeof(msg)-1;
}

static int hello_open(struct inode *inode, struct file *filp)
{
   pr_info(KBUILD_MODNAME ": ""device open\n");
   return 0;
}

static int hello_release(struct inode *inode, struct file *filp)
{
   pr_info(KBUILD_MODNAME ": ""device close\n");
   return 0;
}

static const struct file_operations hello_fops = {
   .owner = THIS_MODULE,
   .read = hello_read,
   .open = hello_open,
   .release = hello_release,
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
