#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/mm.h>
#include <linux/of_irq.h>
#include <linux/dma-mapping.h>

static const uint16_t scale = 5;

static uint16_t *src_base, *dst_base;

static irqreturn_t scldev_irq_handler(int irq, void *dev_id)
{
    return IRQ_WAKE_THREAD;
}

static irqreturn_t scldev_irq_thread(int irq, void *dev_id)
{
    struct device *dev = dev_id;
    bool check = true;

    for (int i = 0; i < (PAGE_SIZE / sizeof(uint16_t)); i++) {
        if (dst_base[i] != i * scale) {
            check = false;
            dev_info(dev, "bad: i = %d, data = %u\n", i, dst_base[i]);
        }
    }

    dev_info(dev, "check = %u\n", check);

    return IRQ_HANDLED;
}

static int scldev_probe(struct platform_device *pdev)
{
    struct device *dev = &pdev->dev;
    void __iomem *reg_base;
    int ret;

    reg_base = devm_platform_ioremap_resource(pdev, 0);
    if (IS_ERR(reg_base)) {
        return PTR_ERR(reg_base);
    }

    dev_info(dev, "MMIO at %px\n", reg_base);

    ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
    if (ret)
        dev_err_probe(dev, ret, "failed to set DMA mask\n");

    dma_addr_t src_phys, dst_phys;
    src_base = dmam_alloc_coherent(dev, PAGE_SIZE, &src_phys, GFP_KERNEL);
    dst_base = dmam_alloc_coherent(dev, PAGE_SIZE, &dst_phys, GFP_KERNEL);

    dev_info(dev, "Src. buf at %px (%x)\n",  src_base, src_phys);
    dev_info(dev, "Dst. buf at %px (%x)\n",  dst_base, dst_phys);

    if (!src_base || !dst_base)
        return -ENOMEM;

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0) {
        dev_err(dev, "failed to get IRQ\n");
        return irq;
    }
    dev_info(dev, "got IRQ = %d\n", irq);

    ret = devm_request_threaded_irq(dev, irq,
                                scldev_irq_handler,
                                scldev_irq_thread,
                                IRQF_TRIGGER_RISING,
                                KBUILD_MODNAME, dev);
    if (ret)
        dev_err_probe(dev, ret, "failed to request IRQ\n");

    for (int i = 0; i < (PAGE_SIZE / sizeof(uint16_t)); i++)
        writew_relaxed(i, &src_base[i]);

    wmb();

    iowrite32(src_phys,  reg_base + 0x0);
    iowrite32(dst_phys,  reg_base + 0x4);
    iowrite32(PAGE_SIZE, reg_base + 0x8);
    iowrite32(scale,     reg_base + 0xC);
    iowrite32(0x1,       reg_base + 0x10);

    return 0;
}

static const struct of_device_id scldev_dt_match[] = {{
        .compatible = "drec-fpga-intro,scale-dev",
    }, {},
};
MODULE_DEVICE_TABLE(of, scldev_dt_match);

static struct platform_driver scldev_drv = {
    .probe = scldev_probe,
    .driver = {
        .name = KBUILD_MODNAME,
        .of_match_table = scldev_dt_match,
    },
};

module_platform_driver(scldev_drv);

MODULE_LICENSE("GPL");
