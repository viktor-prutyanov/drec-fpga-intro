#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/mm.h>
#include <asm/pgtable.h>

static int incdev_probe(struct platform_device *pdev)
{
    struct device *dev = &pdev->dev;
    void __iomem *reg_base;

    reg_base = devm_platform_ioremap_resource(pdev, 0);
    if (IS_ERR(reg_base)) {
        return PTR_ERR(reg_base);
    }

    dev_info(dev, "MMIO at %px\n", reg_base);

    iowrite32(0x5, reg_base);

    u32 v1 = ioread32(reg_base);
    u32 v2 = ioread32(reg_base);

    dev_info(dev, "read: 0x%08x\n", v1);
    dev_info(dev, "read: 0x%08x\n", v2);

    return 0;
}

static const struct of_device_id incdev_dt_match[] = {{
        .compatible = "drec-fpga-intro,mmio-dev",
    }, {},
};
MODULE_DEVICE_TABLE(of, incdev_dt_match);

static struct platform_driver incdev_drv = {
    .probe = incdev_probe,
    .driver = {
        .name = KBUILD_MODNAME,
        .of_match_table = incdev_dt_match,
    },
};

module_platform_driver(incdev_drv);

MODULE_LICENSE("GPL");
