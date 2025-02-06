# Icarus Verilog и GTKWave

Программа Icarus Verilog это простое средство для симуляции Verilog-кода.

Эта страница является кратким руководством по установке и использованию программ Icarus Verilog и GTKwave.

**Предполагается, что установлена Ubuntu, Linux Mint или Fedora.**

## Установка

[По этой ссылке](http://iverilog.wikia.com/wiki/Installation_Guide) можно свериться с официальным руководством по установке Icarus Verilog.

### Ubuntu / Linux Mint

```
sudo apt install iverilog
sudo apt install gtkwave
```

### Fedora

```
sudo yum install iverilog
sudo yum install gtkwave
```

Предположим, что у нас есть файл с кодом `dummy.v` со следующим содержанием:

```verilog
module dummy();

wire a = 1;

initial begin
    $dumpvars;
    $display("Hello, World!");
    #10 $finish;
end

endmodule
```

## Компиляция кода

```
iverilog dummy.v -o dummy
```

## Запуск симуляции в Icarus Verilog

```
vvp dummy
```
или
```
./dummy
```

```
VCD info: dumpfile dump.vcd opened for output.
Hello, World!
```

## Открытие дампа с сигналами в GTKWave

```
gtkwave dump.vcd

GTKWave Analyzer v3.3.89 (w)1999-2018 BSI

[0] start time.
[10] end time.
```

Чтобы увидеть сигналы, нужно выбрать их в левой нижней панели и нажать кнопку "Append".
