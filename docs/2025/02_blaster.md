# Программатор USB Blaster

Основано на [этом](https://wiki.archlinux.org/index.php/Altera_Design_Software) руководстве.

## Подключение

Программатор и отладочную плату соедините 10-пиновым кабелем, а также подключите программатор к ПК через USB.

## Настройка

Запустите следующие команды:

```
lsusb
dmesg | tail
```

Вы должны увидеть примерно следующее:

```
$ lsusb
...
Bus 002 Device 003: ID 09fb:6001 Altera Blaster
...
```
и
```
$ dmesg | tail
...
[10474.425647] usb 2-2: new full-speed USB device number 3 using uhci_hcd
[10474.704514] usb 2-2: New USB device found, idVendor=09fb, idProduct=6001
[10474.704516] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[10474.704518] usb 2-2: Product: USB-Blaster
[10474.704519] usb 2-2: Manufacturer: Altera
[10474.704520] usb 2-2: SerialNumber: 00000000
```

Это означает, что USB Blaster обнаружен операционной системой.

От **root'а** создайте файл `/etc/udev/rules.d/51-altera-usb-blaster.rules` со следующим содержимым:

```
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE="0666"
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666"
```

Это файл нужен, чтобы обычные пользователи (не только root), могли пользоваться устройством.

Теперь выполните следующую команду, чтобы менеджер устройств [udev](https://wiki.archlinux.org/index.php/udev_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)) обнаружил файл с новыми правилами, который мы только что создали.

```
sudo udevadm control --reload
```

Теперь в Quartus'е можно использовать _Tools > Programmer_ чтобы прошивать FPGA на отладочной плате.

## Решение проблем

Методом ниже можно пользоваться, если Quartus сам не может запустить JTAG-сервер.
 
### Запуск JTAG-сервера в ручную

В **отдельном терминале** (например, в новом окне и вкладке терминала) перейдите в каталог с Quartus'ом и запустите JTAG-сервер:

```
cd ~/intelFPGA_lite/18.1/quartus/bin
sudo ./jtagd --debug --foreground
```

Этот терминал **не закрывайте**.

### Проверка работы JTAG

Вернитесь в исходный терминал и там тоже перейдите в каталог с Quartus'ом, и проверьте, что JTAG работает:

```
cd ~/intelFPGA_lite/18.1/quartus/bin
sudo ./jtagconfig --debug
```

Если сделаны правильные настройки на ПК, плата и программатор подключены, то вывод должен быть примерно следующий:

```
1) USB-Blaster [1-3]
  020F10DD   EP3C(10|5)/EP4CE(10|6) (IR=10)

  Captured DR after reset = (020F10DD) [32]
  Captured IR after reset = (155) [10]
  Captured Bypass after reset = (0) [1]
  Captured Bypass chain = (0) [1]
  JTAG clock speed 6 MHz
```

Здесь видно, что USB-Blaster пытается определить, к какому семейству относится данная FPGA. Видно, что EP4CE6 подходит под `EP3C(10|5)/EP4CE(10|6)`.

### Если JTAG-сервер не стартует

Если при запуске `jtagd`, возникает примерное такое сообщение:
```
Can't bind to TCP port 1309 - exiting
```
Скорее всего, это означает, что JTAG-сервер `jtagd` уже запущен и занял один из портов. Проще всего остановить его следующей командой:
```
sudo killall -9 jtagd
```
После чего можно снова запускать `jtagd`.
