fatload mmc 0 0x3000000 uImage
fatload mmc 0 0x2A00000 system.dtb
fatload mmc 0 0x2000000 uramdisk.image.gz
bootm 0x3000000 0x2000000 0x2A00000