# Quartus 18.1

Руководство по установке Quartus Prime 18.1 Lite Edition.

## Загрузка

Загрузите следующие 2 файла с [Intel Download Center for FPGAs](http://fpgasoftware.intel.com/18.1/?edition=lite):

- Quartus Prime Lite Edition
- Cyclone IV device support

Точные имена этих файлов могут зависеть от ОС:

### Linux

- `QuartusLiteSetup-18.1.{minor_version}.run`
- `cyclone-18.1.{minor_version}.qdz`

Минорные версии так же могут быть различными.

## Установка

### Linux

Разместите скачанные файлы **в одном каталоге**. Файлу `.run` нужно дать права на исполнение и запустить его, например так:

```
chmod +x ~/Downloads/QuartusLiteSetup-18.1.0.625-linux.run
./Downloads/QuartusLiteSetup-18.1.0.625-linux.run
```

Должен запуститься графический установщик. Удостоверьтесь, что опция "Cyclone IV device support" включена. Теперь просто пройдите процесс установки до конца.

В каталоге, где установлен Quartus, например, `/home/user/intelFPGA_lite/`, есть подкаталог `18.1/quartus/bin/`.
В нем есть исполняемый файл `quartus`. Находясь в этом каталоге, запустить Quartus можно вот так:
```
./quartus
``` 

Можно добавить Quartus в `PATH` чтобы запускать его из любого каталога:

```
export PATH=$PATH:/home/user/intelFPGA_lite/18.1/quartus/bin
```