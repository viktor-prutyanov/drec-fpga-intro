#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_irq.h>
#include <linux/mm.h>

static atomic_t irq_cnt = {0};

static irqreturn_t key_irq_handler(int irq, void *dev_id)
{
    struct device *dev = dev_id;
    atomic_inc(&irq_cnt);
    dev_info(dev, "IRQ context (%c)\n", in_irq() ? 'Y' : 'N');
    return IRQ_WAKE_THREAD;
}

static irqreturn_t key_irq_thread(int irq, void *dev_id)
{
    struct device *dev = dev_id;
    dev_info(dev, "IRQ context (%c) cnt = %d\n", in_irq() ? 'Y' : 'N',
             atomic_read(&irq_cnt));
    return IRQ_HANDLED;
}

static int keydev_probe(struct platform_device *pdev)
{
    struct device *dev = &pdev->dev;

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0) {
        dev_err(dev, "failed to get IRQ\n");
        return irq;
    }
    dev_info(dev, "got IRQ = %d\n", irq);

    int ret = devm_request_threaded_irq(dev, irq,
                                key_irq_handler, key_irq_thread,
                                IRQF_TRIGGER_RISING,
                                KBUILD_MODNAME, dev);
    if (ret) {
        dev_err(dev, "failed to request IRQ\n");
        return ret;
    }

    return 0;
}

static const struct of_device_id keydev_dt_match[] = {{
        .compatible = "drec-fpga-intro,mmio-dev",
    }, {},
};
MODULE_DEVICE_TABLE(of, keydev_dt_match);

static struct platform_driver keydev_drv = {
    .probe = keydev_probe,
    .driver = {
        .name = KBUILD_MODNAME,
        .of_match_table = keydev_dt_match,
    },
};

module_platform_driver(keydev_drv);

MODULE_LICENSE("GPL");
