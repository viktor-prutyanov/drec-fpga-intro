.text
.globl _start
.globl _finish

_start:
    li      x11,    0x720
    li      x15,    0x722
    add     x11,    x11,    x15 # x11 <- 0xe42
    li      x7,     0x10
    sw      x11,    0x10(x7)    # [0x20] <- 0xe42

_finish:
    nop
.rept 2
    nop
.endr
