.text
.globl _start
.globl _finish

_start:
    li      t0, 0x123
    sw      t0, 0x20(zero)  # Show on hex display

_finish:
    nop
.rept 5
    nop
.endr
