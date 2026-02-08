#include <linux/init.h>   // For __init, __exit
#include <linux/module.h> // For any module
#include <linux/kernel.h> // For printing

MODULE_LICENSE("GPL");
MODULE_VERSION("1.0");

static int __init hello_init(void) // Entry point
{
   pr_info(KBUILD_MODNAME ": ""Hello World!\n");

   return 0; // Success
}

static void __exit hello_exit(void)
{
   pr_info(KBUILD_MODNAME ": ""Goodbye World!\n");
}

module_init(hello_init);
module_exit(hello_exit);

