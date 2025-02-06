.text
.globl _start
.globl _finish

_start:
    li      t0, 0x146       # Letter F + start
    sw      t0, 0x30(zero)  # Send to UART
    li      t0, 0x46        # Letter F
    sw      t0, 0x30(zero)  # Send to UART

_finish:
    nop
.rept 3
    nop
.endr
