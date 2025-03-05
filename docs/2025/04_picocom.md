# UART

Для работы с UART можно использовать программу `picocom`.

## Установка

### Ubuntu / Linux Mint

```
sudo apt install picocom
```

### Fedora

```
sudo yum install picocom
```

## lsusb

О наличии соединения ПК с USB-UART адаптером CH340 на плате можно узнать с помощью `lsusb`.

```
lsusb -d 1a86:
```

## picocom

Битрейт указывается через параметр `-b`.

```
sudo picocom -b 2000000 /dev/ttyUSB0
```

## Пример использования

[![asciicast](https://asciinema.org/a/706692.svg)](https://asciinema.org/a/706692)
