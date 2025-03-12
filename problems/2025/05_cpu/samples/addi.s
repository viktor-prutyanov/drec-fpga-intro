.text
.globl _start
.globl _finish

_start:
    li    x5,  11
    addi  x7,  x5,  9
    nop
    mv    x11, x7

_finish:
    nop
