# Установка Vivado 2025.1

## Подготовка

Список официально поддерживаемых дистрибутивов Linux для Vivado 2025.1:
* Ubuntu: 20.04, 22.04, 24.04
* AlmaLinux: 8.7, 8.10, 9.1, 9.4
* RHEL: 7.9, 8.8, 8.9, 8.10, 9.2, 9.3, 9.4
* CentOS: 7.9

Перед началом установки, чтобы установить необходимые библиотеки, нужно скопировать скрипт `installLibs.sh` на любой R/W-раздел и запустить.
Если дистрибутив не в ходит в список выше, библиотеки нужно установить самостоятельно. Установка на LinuxMint аналогична установке на Ubuntu.

## Установка

Для начала установки надо запустить скрипт `xsetup`.

### Select Product to Install

На этой странице следует выбрать пункт "Vitis", чтобы была установлена не только среда Vivado, но и Vitis Unified IDE.

<img width="926" height="737" alt="image" src="https://github.com/user-attachments/assets/86f80f83-b22f-4ac0-88e7-19b037b0d7f0" />

### Vitis Unified Software Platform

На этой странице из списка устройств следует обязательно выбрать "Zynq-7000 All Programmable SoC".

<img width="929" height="711" alt="image" src="https://github.com/user-attachments/assets/875b2fa6-9b62-41ef-ae95-a7f7b90d3586" />

### Installation Progress

Проуесс устнаовки займет некоторое время.

<img width="932" height="711" alt="image" src="https://github.com/user-attachments/assets/26005e82-3605-4821-808f-e3ed919b0cc1" />

## Настройка окружения

Чтобы Vivado и Vitis можно было запускать из терминала находясь в любом каталоге, можно добавить подобную строку в `.bashrc`:
```
source /ваш/путь/к/Xilinx/2025.1/Vitis/settings64.sh
```
