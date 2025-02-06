.text
.globl _start
.globl _finish

.macro putchar_uart c
    li      t0, \c
    ori     t0, t0,     0x100
    sw      t0, 0x30(zero)
    andi    t0, t0,     0xFF
    sw      t0, 0x30(zero)

_delay\c:
    addi    t1, t1,     1024
    bnez    t1, _delay\c
.endm

_start:
    putchar_uart 0x46
    putchar_uart 0x50
    putchar_uart 0x47
    putchar_uart 0x41
    putchar_uart 0x0D
    putchar_uart 0x0A

    beqz zero, _start

_finish:
    nop
.rept 20
    nop
.endr
