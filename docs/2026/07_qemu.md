# QEMU

Склонируем репозиторий QEMU на версии 9.2:

```
git clone --depth 1 --branch stable-9.2 git@github.com:qemu/qemu.git
cd qemu
```

Скомпилируем QEMU c поддержкой 32-битной ARM платформы и возможностью отладки:

```
./configure --target-list=arm-softmmu --enable-debug
make -j`nproc`
```

В катлоге `build` должен появиться исполняемый файл `qemu-system-arm`.

Выведем список поддерживаемых машин:

```
qemu-system-arm -M ?
```

Выведем список моделей CPU для машины virt:

```
qemu-system-arm -M virt -cpu ?
``` 

Запустим машину `QEMU 9.2 ARM Virtual Machine` c ARM Cortex-A15 без графики:

```
qemu-system-arm -M virt -cpu cortex-a15 -nographic
```

Машина запустится, но ничего не произойдет, поскольку нет ПО, которое может быть запущено.

Чтобы остановить машину, нужно набрать `Ctrl+A X`.

## PL011 UART

См. пример [07_qemu_pl011](https://github.com/viktor-prutyanov/drec-fpga-intro/tree/master/examples/2026/07_qemu_pl011).

