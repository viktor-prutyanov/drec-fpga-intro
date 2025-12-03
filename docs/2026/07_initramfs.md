# initramfs

Создадим файл `hello.c`:

```c
#include <stdio.h>

void main() {
    printf("Hello World!\n");
    while (1);
}
```

Произведем статическую (чтобы не зависеть от динамических библиотек) кросс-компиляцию под 32-битный ARM:

```sh
arm-linux-gnueabi-gcc -static hello.c -o hello
```

Создадим CPIO-архив `rootfs.img` с файлом `hello` внутри:

```sh
echo hello | cpio -o --format=newc > rootfs.img
```

Формат `newc` - это формат архива с initramfs, который распознает ядро Linux.

Содержимое CPIO можно проверить следующим образом:

```sh
cpio -t < rootfs.img
```

Архив `rootfs.img` содержит файл `hello`:

```
rootfs.img
hello
1019 blocks
```

Запустим QEMU с ядром Linux и `rootfs.img` в качестве initramfs и с помощью ключа `-append` передадим _опцию загрузки ядра_ `rdinit`.

```sh
qemu-system-arm -M virt -cpu cortex-a15 -kernel zImage -nographic -initrd rootfs.img -append "rdinit=/hello"
```

После зарузки ядра Linux и монтирования initramfs в `/`, управление будет передано программе `hello`:

```
[    8.397420] Run /hello as init process
Hello World!
```

