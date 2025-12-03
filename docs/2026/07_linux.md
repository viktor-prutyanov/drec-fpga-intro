# Linux Kernel

Клонируем Linux на версии 6.17:

```sh
git clone --depth 1 --branch linux-6.17.y git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
cd linux
```

Создадим отдельную директорию для артефактов сборки:

```sh
mkdir build
```

## Конфигурация

Используем `defconfig` для конфигурации:

```sh
make ARCH=arm O=build defconfig
```
 
Появляется сообщение, что это конфигурация для ARMv7 (32 бита):

```
*** Default configuration is based on 'multi_v7_defconfig'
#
# configuration written to .config
#
```

В каталоге `build` будет создан файл `.config`:

```sh
file build/.config
```

Конфиг можно дополнительно отредактировать через TUI:

```sh
make ARCH=arm O=build menuconfig
```

Можно проверить, что включена поддержка PL011 UART:

```sh
grep "PL011" build/.config 
```

Символ `y` означает, что драйвер PL011 будет включен в образ ядра:

```
CONFIG_SERIAL_AMBA_PL011=y
CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
```

## Компиляция

```sh
yes "" | make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-gcc- O=build -j zImage
```

```
  Kernel: arch/arm/boot/Image is ready
  Kernel: arch/arm/boot/zImage is ready
```

Файлы `Image` и `zImage` представляют собой разные форматы образа ядра:

```sh
file zImage 
```

```
zImage: Linux kernel ARM boot executable zImage (little-endian)
```

## Запуск

Запустим QEMU с собранным ядром Linux:

```sh
qemu-system-arm -M virt -cpu cortex-a15 -kernel zImage -nographic
```

В консоль будет выводиться лог загрузки ядра:

```
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 6.17.5 (user@dev_17) (arm-linux-gnueabi-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #1 SMP Fri Oct 24 01:18:24 MSK 2025
[    0.000000] CPU: ARMv7 Processor [414fc0f0] revision 0 (ARMv7), cr=10c5387d
.........................
[    0.000000] OF: fdt: Machine model: linux,dummy-virt
.........................
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x0000000047ffffff]
.........................
[    1.273829] Serial: AMBA PL011 UART driver
[    1.785831] 9000000.pl011: ttyAMA0 at MMIO 0x9000000 (irq = 28, base_baud = 0) is a PL011 rev1
[    1.796603] printk: console [ttyAMA0] enabled
.........................
[    7.914367] check access for rdinit=/init failed: -2, ignoring
[    7.939104] /dev/root: Can't open blockdev
[    7.941887] VFS: Cannot open root device "" or unknown-block(0,0): error -6
[    7.942347] Please append a correct "root=" boot option; here are the available partitions:
.........................
[   15.468376] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[   15.529803] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.5 #1 NONE 
[   15.538846] Hardware name: Generic DT based system
[   15.548732] Call trace: 
[   15.564334]  unwind_backtrace from show_stack+0x10/0x14
[   15.575432]  show_stack from dump_stack_lvl+0x50/0x64
[   15.576609]  dump_stack_lvl from vpanic+0xf4/0x314
[   15.577724]  vpanic from __do_trace_suspend_resume+0x0/0x4c
[   15.586911] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0) ]---
```

Ядро запустилось, но не смогло найти программу, которая могла бы выполнить роль _init-процесса_, и аварийно прекратило работу.
