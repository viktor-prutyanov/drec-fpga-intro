.text
.globl _start
.globl _finish

_start:
    addi x5,  x0,  11
    addi x7,  x5,   9
    addi x0,  x0,   0
    addi x11, x7,   0
    addi x7,  x7,  -5

_finish:
    nop
    nop
    nop
