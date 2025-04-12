.text
.globl _start
.globl _finish

_start:  
    li      a0, 0
    li      a1, 845
    li      t4, 1
    li      t5, 2

_sqrt:
    lui     t0, 0x40000
    mv      t1, zero

_loop0:     
    or      t2, t1, t0
    srl     t1, t1, t4
    sltu    t3, a1, t2
    bnez    t3, _l1
    sub     a1, a1, t2
    or      t1, t1, t0

_l1:     
    srl     t0, t0, t5
    bnez    t0, _loop0
    mv      a0, t1
    sw      a0, 0x20(zero)

_finish:
    beqz    zero,  _finish