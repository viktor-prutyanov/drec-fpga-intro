# Установка Quartus 23.1.1

Руководство по установке Quartus Prime 23.1.1 Lite Edition в Linux.

## Загрузка

Загрузите следующие 2 файла с [Intel Download Center for FPGAs](http://fpgasoftware.intel.com/):

- Quartus Prime Lite Edition
- Cyclone IV device support

- `QuartusLiteSetup-23.1std.1.{minor_version}-linux.run`
- `cyclone-23.1std.1.{minor_version}.qdz`

Минорные версии могут быть различными.

## Установка

Разместите скачанные файлы **в одном каталоге**. Файлу `.run` нужно дать права на исполнение и запустить его, например так:

```
chmod +x ~/Downloads/QuartusLiteSetup-23.1std.1.993-linux.run
./Downloads/QuartusLiteSetup-23.1std.1.{minor_version}-linux.run
```

Должен запуститься графический установщик. Удостоверьтесь, что опция "Cyclone IV device support" включена. Теперь просто пройдите процесс установки до конца.

В каталоге, где установлен Quartus, например, `/home/user/intelFPGA_lite/`, есть подкаталог `23.1std/quartus/bin`.
В нем есть исполняемый файл `quartus`. Находясь в этом каталоге, запустить Quartus можно вот так:
```
./quartus
``` 

Можно добавить Quartus в `PATH` чтобы запускать его из любого каталога:

```
export PATH=$PATH:/home/user/intelFPGA_lite/23.1std/quartus/bin
```
