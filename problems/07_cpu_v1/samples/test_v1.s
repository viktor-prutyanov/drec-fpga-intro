.text
.globl _start
.globl _finish

_start:
    xori x5,  x0,  11
    ori  x6,  x0,  12
    add  x7,  x5,  x6
    or   x8,  x7,  x6
    and  x9,  x8,  x7
    xor  x10, x9,  x8
    andi x11, x10, 15

_finish:
    nop
