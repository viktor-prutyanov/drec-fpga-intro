.text
.globl _start
.globl _finish

_start:
    li      t0, 0   # fib(0)
    li      t1, 1   # fib(1)
    li      t2, 0   # fib(-1)

    li      t3, 1   # n counter
    li      t4, 24  # max n counter

    li      t5, 0   # init delay counter

_next:
    add     t2, t1,     t0  # fib(n) = fib(n - 1) + fib(n - 2)
    sw      t2, 0x20(zero)  # display fib(n)

_delay:
    addi    t5, t5,     128     # increment delay counter, assume t5 = 0
    bne     t5, zero,   _delay  # next delay loop (~700ms)

    mv      t0, t1
    mv      t1, t2
    addi    t3, t3,     1       # increment counter
    bne     t3, t4,     _next   # next iteration

_delay2:
    addi    t5, t5,     32      # increment delay counter, assume t5 = 0
    bne     t5, zero,   _delay2 # next delay loop (~2.8s)

    beq     zero, zero, _start

_finish:
    nop
.rept 14
    nop
.endr
