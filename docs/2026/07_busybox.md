# BusyBox

Склонируем BusyBox v1.36:

```sh
git clone --depth 1 --branch 1_36_stable git@github.com:mirror/busybox.git
cd busybox
```

## Сборка BusyBox

Скомплировать нужно статический исполняемый файл (без линковки с динамическими библиотеками):

```sh
CROSS_COMPILE=arm-linux-gnueabi- LDFLAGS=--static ARCH=arm make defconfig
CROSS_COMPILE=arm-linux-gnueabi- LDFLAGS=--static ARCH=arm make install -j CONFIG_PREFIX=../rootfs
cd ../rootfs
```

В каталоге `rootfs` будет развернутый образ BusyBox.

## Подготовка initramfs

Добавим каталоги, в которые будут смонтированы procfs, sysfs, devtmpfs, а так же каталог для init-скриптов:

```sh
mkdir -p proc sys dev etc/init.d
```

Создадим init-скрипт `etc/init.d/rcS`:

```sh
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mdev -s
```

Добавим ему разрешение на запуск:

```sh
chmod +x etc/init.d/rcS
```

Соберем initramfs в единый CPIO-архив:

```sh
find . | cpio -o --format=newc > ../rootfs.img
```

## Запуск

Запустим QEMU с initramfs на основе BusyBox:

```sh
qemu-system-arm -M virt -cpu cortex-a15 -kernel zImage -nographic -initrd rootfs.img -append "rdinit=/sbin/init"
```

После загрузки ядра Linux, управление будет передано в _систему инциализации_ `/sbin/init`, которую из коробки предоставляет BusyBox.

Система инициализации выполнит init-скрипт `etc/init.d/rcS` и предоставит консольный доступ:

```
[    7.680274] Run /sbin/init as init process

Please press Enter to activate this console. 
~ # 
```

BusyBox предоставляет различные популярные консольные UNIX-утилиты, такие как `cat` и многие другие:

```
~ # cat /proc/cpuinfo 
processor	: 0
model name	: ARMv7 Processor rev 0 (v7l)
BogoMIPS	: 125.00
Features	: half thumb fastmult vfp edsp thumbee neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x4
CPU part	: 0xc0f
CPU revision	: 0

Hardware	: Generic DT based system
Revision	: 0000
Serial		: 0000000000000000
```