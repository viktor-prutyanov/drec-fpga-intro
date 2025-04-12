.text
.globl _start
.globl _finish
.globl main

_start:
    li      sp, 0x1200
    call    main

_finish:
    beqz    zero,  _finish

