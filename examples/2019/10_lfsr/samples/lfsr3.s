.text
.globl _start
.globl _finish

_start:
    li  t0, 1   # initial state
    li  a0, 1
    li  t2, 4

_next:
    sw      t0, 0x20(zero)
    andi    t1, t0, 1
    srli    t0, t0, 1
    beq     t1, zero, _next
    xor     t0, t0, a0
    or      t0, t0, t2
    beq     zero, zero, _next

_finish:
    nop
