.text
.globl _start
.globl _finish

_start:
    li   x5, 0
    li   x6, 4
_loop:
    addi x5, x5, 1
    sw   x5, 0x20(zero)
    bne  x5, x6, _loop

_finish:
    nop
