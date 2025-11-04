# QEMU

Склонируем репозиторий QEMU на версии 9.2:

```sh
git clone --depth 1 --branch stable-9.2 git@github.com:qemu/qemu.git
cd qemu
```

Скомпилируем QEMU c поддержкой 32-битной ARM платформы и возможностью отладки:

```sh
./configure --target-list=arm-softmmu --enable-debug
make -j`nproc`
```

В катлоге `build` должен появиться исполняемый файл `qemu-system-arm`.

Выведем список поддерживаемых машин:

```sh
qemu-system-arm -M ?
```

Выведем список моделей CPU для машины virt:

```sh
qemu-system-arm -M virt -cpu ?
``` 

Запустим машину `QEMU 9.2 ARM Virtual Machine` c ARM Cortex-A15 без графики:

```sh
qemu-system-arm -M virt -cpu cortex-a15 -nographic
```

Машина запустится, но ничего не произойдет, поскольку нет ПО, которое может быть запущено.

Чтобы остановить машину, нужно набрать `Ctrl+A X`.

## Monitor

Запуск машины с перенаправлением QEMU monitor (HMP) в порт 1234 по протоколу Telnet:

```sh
qemu-system-arm -M virt -monitor telnet:127.0.0.1:1234,server,nowait
```

Подключение через Telnet:
 
```sh
telnet 127.0.0.1 1234
```
